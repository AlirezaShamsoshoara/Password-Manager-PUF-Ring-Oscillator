# Password-Manager-PUF-Ring-Oscillator
This project aims at using the Ring Oscillator as a Physical Unclonable Function (PUF) for the password management scheme. 

## Report
You can find the report published on Arxiv at [this link](https://arxiv.org/pdf/1901.06733.pdf).

## Summary
The goal is to use the Physical behavior of a Ring Oscillator (RO) such as reistance and capacitance values to generate random frequencies. Later, these frequencies were used for the comparison to generate binary stream. The binary stream is given to a hash function to generate a hash value. In authentication, if the hash value is different from what registered before then it doesn't if the password is the same or not. Since, it means the device is different, it is not going to authenticate with that. 

## Design
The RO is implemented in both hardware and software (simulation). A Raspberry Pi is used to measure the frequuency of different channels and extract the exact value. Later, those values are given to a server(Laptop or PC) from the Raspberry Pi to generate the binary stream and the hash value. Also, the password management scheme is implemented in the Computer. The interface between the Computer and the Raspberry Pi is TCP/IP using CAT5/6 cable. The IP addresses are set manually in both R Pi and PC. This design is demonstrated here:<br/><br/>
![Alt text](/images/p13.PNG)


## Simulation
To analyze the RO, first, we developed that in a simulation environment (Proteus Environment) to import electronics components such as rasistrors, MUX, DE-MUX, Capacitors, Op-Amps, NAND gates, Inverters, etc. The simulation environment is [Proteus Labcenter](https://www.labcenter.com/simulation/). It is possible to implement that in other simulators as well. The design is depicted in:<br/><br/>
![Alt text](/images/p6.png)

Also, the file is available here at [Design](https://github.com/AlirezaShamsoshoara/Password-Manager-PUF-Ring-Oscillator/blob/main/Pr4.DSN).

## Hardware
To implement the RO on breadboard, we used different ressistors, capacitors, and ICs of 74HC04 and 74HC00 for NOT and NAND gates. The structure of this RO is displayere here:
<br/><br/>
![Alt text](/images/original.png)
<br/><br/>
To read the frequency values from the hardware and compare it with the Raspberry Pi measurement, we used a logic analyzer for different channels. Here is the output of the logic analyzer displayed in computer via a USB interface:
<br/><br/>
![Alt text](/images/p12.png)

This logic analyzer is available on many websites such as [Amazon](https://www.amazon.com/HiLetgo-Analyzer-Ferrite-Channel-Arduino/dp/B077LSG5P2/ref=sr_1_3?ie=UTF8&qid=1525562576&sr=8-3&keywords=logic+analyzer).

## Code
### Required packages for this projects are:<br/>
* os
* time
* socket
* RPi.GPIO
* DataHash



### Different codes are associated with project.<br/>
* The Python file is used on Raspberry Pi to read the output of the hardware for different channel of frequencies. This file is called [calculate.py](https://github.com/AlirezaShamsoshoara/Password-Manager-PUF-Ring-Oscillator/blob/main/calculate.py). <br/>
* The password management scheme is implemented in Matlab and called [passwordMngmnt.m](https://github.com/AlirezaShamsoshoara/Password-Manager-PUF-Ring-Oscillator/blob/main/passwordMngmnt.m). <br/>
* To generate the hash value, we used an available hash function from math works [DataHash.m](https://github.com/AlirezaShamsoshoara/Password-Manager-PUF-Ring-Oscillator/blob/main/DataHash.m). However, a new version of this hash function is available on [MathWorks](https://www.mathworks.com/matlabcentral/fileexchange/31272-datahash).

## GUI
The Graphical User Interface (GUI) is designed in Matlab for the user to test the password management scheme. The designed GUI is demonstrated here:
<br/><br/>
![Alt text](/images/p16.png)
<br/><br/>
The design file is called [tutorialApp.mlapp](https://github.com/AlirezaShamsoshoara/Password-Manager-PUF-Ring-Oscillator/blob/main/tutorialApp.mlapp).


## Citation
If you find the code or the article useful, please cite our paper using this BibTeX:
```
@article{shamsoshoara2019ring,
  title={Ring oscillator and its application as physical unclonable function (puf) for password management},
  author={Shamsoshoara, Alireza},
  journal={arXiv preprint arXiv:1901.06733},
  year={2019}
}
```

