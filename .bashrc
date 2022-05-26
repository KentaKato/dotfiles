# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Original .bashrc
source /etc/skel/.bashrc

# Add user's private bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Share history between terminals
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
shopt -u histappend

# vi
export EDITOR=vim
set -o vi

# Ethernet IP
export MY_ETH0IP=`ifconfig eno1 | grep -o -E "([0-9]+\.){3}[0-9]+" | head -n1`

# ROS
if [ -d "/opt/ros" ]; then
    test "$ROS_DISTRO" = "" && export ROS_DISTRO=melodic # [melodic|noetic]
    if [ "$ROS_DISTRO" = "melodic" ]; then
        source /opt/ros/melodic/setup.bash
        source /usr/lib/python2.7/dist-packages/catkin_tools/verbs/catkin_shell_verbs.bash
    elif [ "$ROS_DISTRO" = "noetic" ]; then
        source /opt/ros/noetic/setup.bash
        source /usr/lib/python3/dist-packages/catkin_tools/verbs/catkin_shell_verbs.bash
    else
        echo "Invalid ROS_DISTRO `$ROS_DISTRO` was given."
    fi

    export ROS_IP=$(echo $MY_ETH0IP localhost|cut -d' ' -f1)
    export ROS_MASTER_URI=http://$(echo $MY_ETH0IP localhost|cut -d' ' -f1):11311
    export ROS_HOSTNAME=$(hostname).local
fi

# alias and func. for ROS
alias cs="catkin source"
alias cb="catkin build"
alias ct="catkin build --this"
rp() {
	path=$1
	cd ~/${path}/src
	catkin source
}

# peco
peco_search_history() {
    local l=$(HISTTIMEFORMAT= history | \
    sort -r | sed -E s/^\ *[0-9]\+\ \+// | \
    peco --query "$READLINE_LINE")
    READLINE_LINE="$l"
    READLINE_POINT=${#l}
}
bind -x '"\C-r": peco_search_history'



