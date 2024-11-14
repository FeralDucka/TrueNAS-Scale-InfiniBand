# TrueNAS-Scale-InfiniBand
This is a script that will allow you to install and configure the necessary sofwtare and modules to make InfiniBand (<b>MLX4 / ConnectX-3</b>) work with you <b>TrueNAS Scale</b> installation.<br>
<br>
Open a shell in your machine and run:
```
wget https://raw.githubusercontent.com/FeralDucka/truenas-scale-infiniband/main/run.sh -O - | bash
```
<br>

In the web interface, <b>add 2 Pre-Init scripts with the following commands</b>, to set the InfiniBand interface in DATAGRAM mode and set MTU at 65520.
```
echo connected > /sys/class/net/<INFINIBAND INTERFACE NAME>/mode
```
```
ip link set <INFINIBAND INTERFACE NAME> mtu 65520
```
<br>

# Resources
Special thanks go to <b>XtremeOwnage</b> and their useful guides on their website.
<ul>
  <li>https://static.xtremeownage.com/blog/2022/truenas-scale---enable-apt-get</li>
  <li>https://xtremeownage.com/2022/03/26/truenas-scale-infiniband</li>
</ul>
