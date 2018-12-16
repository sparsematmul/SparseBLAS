all: test2make csrmake normmake kijmake
test2make: test2.cpp
	g++ -I ../eigen -I ../sniper-6.1/include/ -O0 test2.cpp -o test2

csrmake: csrimpl.cpp
	g++ -I ../sniper-6.1/include/ -O0 csrimpl.cpp -o csrimpl

normmake: norm.cpp
	g++ -I ../sniper-6.1/include/ -O0 norm.cpp -o norm

kijmake: kij.cpp
	g++ -I ../sniper-6.1/include/ -O0 kij.cpp -o kij
