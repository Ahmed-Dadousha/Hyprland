#!/bin/bash
# Get avilable usb block devices
usbs=$(ls -lahF /sys/block | rg usb | cut -d '/' -f 12 | xargs -I {} lsblk -nr --output NAME,SIZE,LABEL,MOUNTPOINT /dev/{} | rg 'sd[a-z]+[0-9]+' | awk '{printf "󰕓 %-10s %-10s %-10s %s\n", $1, $2, $3, $4}')

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
    device=$(echo -e "$devices" | rofi -dmenu -theme-str 'window {width: 35%;}' -p "󱇰 USB Devices: ")
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
        # Get Selected device filesystem type
        fs_type=$(lsblk -no FSTYPE /dev/$usb_name)
        
        # Assign a name to selected device if it is empty
        [ -z "$usb_label" ] || [ "$usb_label" == "/mnt/USB/New_Volume" ] && usb_label="New_Volume"
        # If it's not ext4
        if [[ "$fs_type" == "ntfs" || "$fs_type" == "vfat" || "$fs_type" == "fat32" || "$fs_type" == "exfat" ]]; then
        # Create a directory with selected device label and mount it to the directory
        ! mountpoint -q "/mnt/USB/$usb_label"  && mkdir -p "/mnt/USB/$usb_label" && sudo mount -o uid=1000,gid=1000 "/dev/$usb_name" "/mnt/USB/$usb_label" && exit 0
    else
        ! mountpoint -q "/mnt/USB/$usb_label"  && mkdir -p "/mnt/USB/$usb_label" && sudo mount "/dev/$usb_name" "/mnt/USB/$usb_label" && sudo chown adosha:adosha "/mnt/USB/$usb_label" && chmod 755 "/mnt/USB/$usb_label" && exit 0
        fi
        # Unmount the selected device and remove the its directory
        sudo umount "/dev/$usb_name" && rmdir "/mnt/USB/$usb_label"
    fi

else
    # If There is no usb devices
    echo -e "" | sed '/^$/d' | rofi -dmenu -p "󱇰 No USB Devices."
fi
