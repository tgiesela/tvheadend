# tvheadend with oscam
Tvheadend with Oscam for SAT>IP server
Tvheadend and Oscam are running in separate containers. Oscam is configured
to use an USB card reader like OMNIKEY. 

## First time configuration
To build the docker containers simply run:

>docker-compose build

After the containers are successfully build you can start them for the first 
time with:

>docker-compose up -d

and subsequent start and stop can be done with:

>docker-compose start
>docker-compose stop

Login to the tvheadend webgui http://<ip-address>:9981/ and finish the 
setup of your SAT>IP server. Tvheadend will find your
SAT>IP server automatically. 
In the general tab set default view level to advanced and enable 
'Conditional Access (for advanced view level). You are now able to add the
oscam server under 'CAs'. Add a new server of type 'CaPMT' with the following
settings:

```
	mode: 					      OSCam net protocol (rev >= 10389)
	Camd.socket filename / IP Address (TCP mode): <ip-address host>
	Listen / Connect port:			      9000
	CW Mode:				      Standard / auto
```

Note: the containers uses a folder to store persisent data:
>/docker/data/tvheadend

