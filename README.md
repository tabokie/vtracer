# vtracer

This project attempts to implement structured parallel program, in which case, a 3D ray casting program.

Each casted ray is sent through tracer bus, and collide against different tracable object. After result summary and color shading, per-pixel color is passed for further usage.

To fully utilize the computing potential, pipelining of object tracing pass is implemented so that the ray spawning rate fixes at 30 clk per ray.

### Structure skeleton:

![skeleton](https://raw.githubusercontent.com/tabokie/verilog-3d-first-person/master/Structure_Diagram.png)

### Machine Test

test pictures for 3D ray tracer run on Nexys 3 (only support limited function due to low amount of computing unit):

Initial:

![first sketch](https://raw.githubusercontent.com/tabokie/verilog-3d-first-person/master/test/test_pic/test_pic_init.jpg)

Rotate right:

![rotate](https://raw.githubusercontent.com/tabokie/verilog-3d-first-person/master/test/test_pic/test_pic_rrotate.jpg)

