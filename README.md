# UE_tools

## CodeGen
Python script to generate UE4 classes to interface with ROS2 messages.

Based on Jinja2.

Ignores message types deprecated in Foxy.

### Usage
`python3 CodeGeneratorFromPath.py <ros2-base-share-path> [<custom-message-path>]`

`ros2-base-share-path` is used to find base definition of types
`custom-message-path` is the path of messages that need to be generated (multiple are allowed)

e.g. `python3 CodeGeneratorFromPath.py /opt/ros/foxy/share/ /opt/ros/foxy/share/geometry_msgs/` generates `geometry_msgs` using definitions in `/opt/ros/foxy/share/` and `/opt/ros/foxy/share/geometry_msgs/`

#### For usage with rclUE
1. `python3 post_generate.py <path to ue project whith have rclUE under Plugins> <path to install> <ros_package_name>`. e.g.

    - installed package `python3 post_generate.py /home/yu/io_amr_UE /opt/ros/foxy example_interfaces`. *you need to install example_interfaces by sudo `apt install ros-foxy-example-interfaces`
    - locally build package `python3 post_generate.py /home/yu/io_amr_UE /home/yu/test_ws/install/ue_msgs ue_msgs`

2. The package name needs to be added to `rclUE.Build.cs` and `ros2lib.Build.cs`, in the `folders` array.
3. Update the `LD_LIBRARY_PATH` in `run_editor.sh` script

Please check the corresponding files and folders in the rclUE Plugin to see how other autogenerated files are handled.

### Limitation
- only works with ROS2 message interface (in particular, ROS had built-in data types, such as `time`, defined in libraries and ROS2 now implements those as messages)
- code generation for nested arrays in messages is not supported
- currently it has only been tested with messages used in RR projects
- not all types are supported in UE4 Blueprint (e.g. `double`): `get_types_cpp` does the check, however it is currently checking against a list of unsupported types that have been encountered (and there's more that are not checked against, so if the code fails compilation due to this problem, the type in question should be currently be added to the list). The alternative, and better implementation, would check for supported types (but must be careful with various aliases, like `int` and `int32`

### Improvements
- use object oriented python
- the script iterates multiple times over the files - this can be avoided if performance is a real issue (messages shouldn't change often however, so clarity should be prioritized over performance
- add automated testing: minimum should be to include all of the generated files and try to compile

### Maintainer
yu.okamoto@rapyuta-robotics.com