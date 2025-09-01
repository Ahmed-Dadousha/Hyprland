#!/bin/bash
# Get avilable usb block devices
usbs=$(ls -lahF /sys/block | rg usb | cut -d '/' -f 12 | xargs -I {} lsblk --output NAME,SIZE,LABEL,MOUNTPOINT /dev/{} | rg 'sd[a-z]+[0-9]+' | sed 's/^../󰕓 /')
# Get avilable phone devices
phones=$(simple-mtpfs -l 2>/dev/null)

# Add phone devices to usb devices if exists
if [ -n "$phones" ]; then
    # Add mountpoint to a phone device
    if [ -n "$(ls -A /mnt/Phone)" ]; then
        mounted="/mnt/Phone"
    fi

    devices=$(echo -e "$usbs\n $phones $mounted" | sed '/^$/d')
else
    devices="$usbs"
fi

# If there is at least a device
if [ -n "$devices" ]; then
    #Choose a usb device
    device=$(echo -e "$devices" | rofi -dmenu -p "󱇰 USB Devices: ")
    letter=$(echo "$device" | cut -d " " -f 1)

    # If the user choosed a phone device
    if [ "$letter" = "" ]; then
        if [ -z "$(ls -A /mnt/Phone)" ]; then

            # Mount the selected pjone device
            simple-mtpfs --device 1 "/mnt/Phone"

        else
            # Unmount the selected phone device
            fusermount -u "/mnt/Phone"
        fi

    # If the user choosed a usb device
    elif [ "$letter" = "󰕓" ]; then
        # Get selected device name
        usb_name=$(echo "$device" | awk '{print $2}')
        # Get Selected device label
        usb_label=$(echo "$device" | awk '{print $4}')

        # Assign a name to selected device if it is empty
        [ -z "$usb_label" ] || [ "$usb_label" == "/mnt/USB/New_Volume" ] && usb_label="New_Volume"
        # Create a directory with selected device label and mount it to the directory
        [ ! -d "/mnt/USB/$usb_label" ] && mkdir "/mnt/USB/$usb_label" && sudo mount "/dev/$usb_name" "/mnt/USB/$usb_label" -o umask=000 && exit
        # Unmount the selected device and remove the its directory
        [ -d "/mnt/USB/$usb_label" ] && sudo umount "/dev/$usb_name" && sudo rm -rf "/mnt/USB/$usb_label"
    fi

else
    # If There is no usb devices
    echo -e "" | sed '/^$/d' | rofi -dmenu -p "󱇰 No USB Devices."
fi
