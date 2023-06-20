1) Install cpmtools

sudo apt install cpmtools

2) Add lines to the end of file /etc/cpmtools/diskdefs

diskdef i1080
  seclen 128
  tracks 160
  sectrk 40
  blocksize 2048
  maxdir 64
  skew 0
  boottrk 2
  os 2.2
end

