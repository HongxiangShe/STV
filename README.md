# STV
这是一个用于练习的直播项目


本文件同目录下的 STV 文件夹为 iOS客户端项目

本文件同目录下的 Server 文件夹为一个极简的Swift书写的运行在MAC端的程序(同样用Xcode打开)

使用前需要先运行Server项目, 运行后出现一个面板, 点击启动按钮, 即为启动一个极简的即时通讯服务器;
接着修改STV项目中Live文件夹下的RoomViewController.swift文件, 将"SHXSocket(addr: "192.168.31.28", port: 7878)"中的"192.168.31.28"修改为你运行Server程序的电脑的IP地址, 修改完后, 运行iOS客户端.

注意: Server项目和STV项目需要在同一局域网内

