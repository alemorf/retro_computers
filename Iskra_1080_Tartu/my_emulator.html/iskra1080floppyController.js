// Iskra 1080 Tartu online emulator
// Copyright 27-Aug-2022 Alemorf, aleksey.f.morozov@yandex.ru

function Iskra1080FloppyController(floppy) {
    const address = 11;
    let state = 0;
    let stateTimeout = 0;
    let control = 0;
    let input = 0;
    let outputL = 0;
    let outputH = 0;
    let inputPacket = [];
    let outputPacket = [];
    let outputPacketPosition = 0;

    function nextState(s) {
        stateTimeout = 100;
        state = s;
    }

    function machine(flags) {
        stateTimeout--;
        if (stateTimeout === 0) {
            console.log("Floppy timeout " + state);
            state = 0;
        }

        switch (state) {
        case 0: // Передача адреса
            outputL = address;
            outputH = 0x40;
            nextState(1);
            break;
        case 1:
            outputH = 0;
            nextState(2);
            break;
        case 2:                       // Ожидание ответа
            if (stateTimeout === 1) { // Не выводим ошибку
                nextState(0);
                break;
            }
            if (control === 1) {
                outputL = 0xFF;
                nextState(3);
            }
            outputH ^= 0x80; // Заврешение неудачной передачи
            break;
        case 3:
            if (control === 0) {
                nextState(6);
                inputPacket = [];
            }
            break;
        case 6: // Передача в компьютер
            if (control === 2) {
                inputPacket.push(input);
                nextState(7);
            }
            break;
        case 7:
            if (control === 0) {
                if (inputPacket[0] + 1 === inputPacket.length) { // Приём закончен
                    processInternal();
                    outputPacketPosition = 0;
                    nextState(8);
                } else {
                    nextState(6);
                }
            }
            break;
        case 8: // Приём из компьютера
            outputH = 0x80;
            outputL = outputPacket[outputPacketPosition];
            nextState(9);
            break;
        case 9:
            if (flags === 1) {
                nextState(10);
            }
            break;
        case 10:
            outputL = 0xFF;
            outputH = 0;
            if (outputPacketPosition + 1 < outputPacket.length) {
                outputPacketPosition++;
                nextState(8);
            } else {
                nextState(0);
            }
            break;
        }
    }

    this.read = function(addr) {
        switch (addr) {
        case 0: // Чтение данных
            machine(1);
            return outputL;
        case 1: // Чтение состояния
            machine(2);
            return outputH | 2 | ((address & 0x0F) << 2);
        }
        return 0;
    };

    this.write = function(data) {
        input = data;
    };

    this.writeControl = function(control_) {
        if (control !== control_) {
            control = control_;
            machine(3);
        }
    };

    function processInternal() {
        // TODO: Проверить КС
        outputPacket = [ // Заголовок ответного пакета
                    0x08, // Длина пакета без контрольной суммы
                    0x01, // В сторону компьютера
                    inputPacket[2], // Адрес компьютера
                    0x00, // Результат
                    inputPacket[4],
                    inputPacket[5],
                    inputPacket[6],
                    inputPacket[7]
                ];
        const result = process();
        outputPacket[0] = outputPacket.length;
        outputPacket[3] = result;
        let sum = 0;
        for (let i in outputPacket)
            sum ^= outputPacket[i];
        outputPacket.push(sum);
    };

    function process() {
        if (inputPacket[0] < 8 || inputPacket[1] !== 0 || inputPacket[2] !== address) {
            console.log("Incorrect packet received " + inputPacket);
            return 1;
        }

        if (inputPacket[3] === 0) { // Read
            if (inputPacket[0] !== 0x8) {
                console.log("Incorrect packet received " + inputPacket);
                return 1;
            }
            const device = 0; // TODO: inputPacket[4];
            const track = inputPacket[5] | (inputPacket[6] << 8);
            const sector = inputPacket[7];
            if (device !== 0) {
                console.log("Read floppy error, incorrect device " + device + "/" + track + "/" + sector);
                return 1;
            }
            const sectorPerTrack = floppy[0].get0(0);
            const offset = sector + track * sectorPerTrack;
            const packet = floppy[device].read(offset);
            if (packet.length == 0 || sector >= sectorPerTrack) {
                console.log("Read floppy error, invalid position " + device + "/" + track + "/" + sector);
                return 1;
            }
            console.log("Read floppy " + device + "/" + track + "/" + sector);
            for (let i = 0; i < 128; i++)
                outputPacket.push(packet[i]);
            return 0;
        }

        if (inputPacket[3] === 1) { // Write
            if (inputPacket[0] !== 0x88) {
                console.log("Incorrect packet received " + inputPacket);
                return 1;
            }
            const device = 0; // TODO: inputPacket[4];
            const track = inputPacket[5] | (inputPacket[6] << 8);
            const sector = inputPacket[7];
            if (device !== 0) {
                console.log("Write floppy error, incorrect device " + device + "/" + track + "/" + sector);
                return 1;
            }
            const sectorPerTrack = floppy[0].get0(0);
            const offset = sector + track * sectorPerTrack;
            let tmp = [];
            for (let i = 0; i < 128; i++)
                tmp[i] = inputPacket[8 + i];
            if (!floppy[device].write(offset, tmp)) {
                console.log("Write floppy error, invalid position " + device + "/" + track + "/" + sector);
                return 1;
            }
            console.log("Write floppy " + device + "/" + track + "/" + sector);
            return 0;
        }

        console.log("Unknown command received " + inputPacket);
        return 1;
    }
}
