all: iskra_1080_tartu_tap_to_wav iskra_1080_tartu_tap_to_wav_exe files

files:
	find . -type f >iskra_1080_tartu_tap_to_wav.files

clean:
	rm iskra_1080_tartu_tap_to_wav iskra_1080_tartu_tap_to_wav.exe

check:
	cppcheck --language=c++ --std=c99 -v --force --enable=all --inconclusive --library=posix --addon=cppcheck.json \
	iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp make_pcm_wav_file.h fs_tools.cpp fs_tools.h

format:
	clang-format -i iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp make_pcm_wav_file.h fs_tools.cpp fs_tools.h

iskra_1080_tartu_tap_to_wav: iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp make_pcm_wav_file.h fs_tools.cpp fs_tools.h
	g++ -static -std=c++17 -oiskra_1080_tartu_tap_to_wav iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp fs_tools.cpp

iskra_1080_tartu_tap_to_wav_exe: iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp make_pcm_wav_file.h fs_tools.cpp fs_tools.h
	i686-w64-mingw32-g++ -static -std=c++17 -oiskra_1080_tartu_tap_to_wav.exe iskra_1080_tartu_tap_to_wav.cpp make_pcm_wav_file.cpp fs_tools.cpp

