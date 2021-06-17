# GreenHouseLightingSystem


I send the new version of lighting system 

Now the duration depend of the value of accumulated radiation at 19:00. 

This is compute in following way: 

Power = 2*200W; <= Power of lighting System

D = 1/Power * (MinRadiation - AcumRad )
Duration  = min( D , MaxDuration )

We have two parameters: 
	- MaxDuration (hours) : 4 h
	- Minimun Accumulated Radiation : 5e6 J

The idea of this formula is that the duration try cover the gap of energy to achieve the “MinRadiation”. If achieve this gap is imposible the duration take his maximum value. 




You can change these parameter in Lighting System Block 



I change the time unit from seconds to days in Simulink Simulation. This is because I see the simulation was very slow. Now the Stop Time in Simulink must be 365 if you want take all year

