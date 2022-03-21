all:
	find . -type f >vector06c_bin_to_wav.files
	g++ -O2 -static -s -o vector06c_bin_to_wav vector06c_bin_to_wav.cpp make_pcm_wav_file.cpp fs_tools.cpp
	i686-w64-mingw32-g++ -O2 -static -s -o vector06c_bin_to_wav.exe vector06c_bin_to_wav.cpp make_pcm_wav_file.cpp fs_tools.cpp

clean:
	rm vector06c_bin_to_wav vector06c_bin_to_wav.exe