# 1. 베이스 이미지
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# 2. 필수 시스템 패키지 설치
RUN apt update && apt install -y \
    bash-completion \
    build-essential \
    ca-certificates \
    curl \
    dnsutils \
    git \
    htop \
    iputils-ping \
    less \
    locales \
    lsb-release \
    man \
    nano \
    net-tools \
    software-properties-common \
    sudo \
    unzip \
    vim \
    wget \
    zip \
    python3-pip \
    python3-opencv \
    libopencv-dev \
    cmake \
    gdb \
    clang-format \
    libeigen3-dev \
    libboost-all-dev \
    dbus-x11 \
    libgl1-mesa-glx \
    libx11-xcb1 \
    && rm -rf /var/lib/apt/lists/*

# 3. locale 설정
RUN locale-gen en_US.UTF-8

# 4. ROS Noetic 설치
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt update && apt install -y \
    ros-noetic-desktop-full \
    python3-rosdep \
    ros-noetic-ros-control \
    ros-noetic-ros-controllers \
    ros-noetic-gazebo-ros \
    ros-noetic-gazebo-ros-control \
    ros-noetic-joint-state-publisher-gui \
    ros-noetic-rqt-robot-steering \
    ros-noetic-teleop-twist-keyboard \
    ros-noetic-turtlebot3-msgs \ 
    ros-noetic-turtlebot3-description \
    ros-noetic-turtlebot3-gazebo \
    ros-noetic-turtlebot3-navigation \
    && rm -rf /var/lib/apt/lists/*

# 5. ROS 환경 설정 및 rosdep 초기화
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN rosdep init && rosdep update

# 6. GitHub에서 catkin_ws clone 후 정리 (삭제 안 함!)
RUN mkdir -p /root/catkin_ws \
    && git clone https://github.com/YuChani/limo_rtabmap.git /tmp/limo_ws \
    && cp -a /tmp/limo_ws/. /root/catkin_ws/ \
    && /bin/bash -c "source /opt/ros/noetic/setup.bash && rosdep install --from-paths /root/catkin_ws/src --ignore-src -r -y || true"

# 7. ROS 워크스페이스 자동 로딩
RUN echo "source /root/catkin_ws/devel/setup.bash" >> /root/.bashrc

CMD ["bash"]
