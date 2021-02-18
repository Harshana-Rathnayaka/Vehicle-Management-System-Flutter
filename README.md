# vehicle_management_system

install flutter version 1.20.3-0.0.pre.1
1.20.2 or 1.20.3 should be fine

* first run the below commands to redirect the phone's desired port to the PC's desired port

== you need to install ADB tools from android studio for this to work

``` bash
adb reverse tcp:8000 tcp:8000
```

* then navigate to your api folder location

``` bash
cd path/folder-name
```

* now run the below command to serve the api

### you will need to add the php.exe file location as a path variable in the environmental variables for this work

``` php
php -S 0.0.0.0:8000
```

* in the app go to *NetwrokHelper.dart* and check if the below line exists. if not add it

``` dart
final String url = "http://0.0.0.0:8000";
```

## the above url is for real devices only.

### use the following if you want to test on emulators

``` dart
final String url = "http://10.0.2.2:8000/api";
```

### Now run the application. It should work 
