#!/bin/bash
sudo pacman -S tlp
# resolving dependencies...
# looking for conflicting packages...

# Packages (2) hdparm-9.56-1  tlp-1.1-1

# Total Download Size:   0.13 MiB
# Total Installed Size:  0.49 MiB

# :: Proceed with installation? [Y/n]
# :: Retrieving packages...
 # hdparm-9.56-1-x86_64
 # tlp-1.1-1-any
# (2/2) checking keys in keyring
# (2/2) checking package integrity
# (2/2) loading package files
# (2/2) checking for file conflicts
# (2/2) checking available disk space
# :: Processing package changes...
# (1/2) installing hdparm
# Optional dependencies for hdparm
    # bash: for wiper.sh script [installed]
# (2/2) installing tlp
# Optional dependencies for tlp
    # acpi_call: ThinkPad battery functions, Sandy Bridge and newer
    # bash-completion: Bash completion
    # ethtool: Disable Wake On Lan
    # lsb-release: Display LSB release version in tlp-stat
    # smartmontools: Display S.M.A.R.T. data in tlp-stat
    # tp_smapi: ThinkPad battery functions
    # x86_energy_perf_policy: Set energy versus performance policy on x86 processors
# :: Running post-transaction hooks...
# (1/3) Reloading system manager configuration...
# (2/3) Reloading device manager configuration...
# (3/3) Arming ConditionNeedsUpdate...
cp /etc/default/tlp ~/tlp
sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_AC=powersave/CPU_SCALING_GOVERNOR_ON_AC=performance/g' /etc/default/tlp
sudo sed -i 's/^#CPU_SCALING_GOVERNOR_ON_BAT=powersave/CPU_SCALING_GOVERNOR_ON_BAT=powersave/g' /etc/default/tlp
echo 'RUNTIME_PM_BLACKLIST="01:00.0"' | sudo tee -a /etc/default/tlp
# RUNTIME_PM_BLACKLIST="01:00.0"
sudo sed -i 's/^#CPU_SCALING_MAX_FREQ_ON_BAT=0/CPU_SCALING_MAX_FREQ_ON_BAT=2200000/g' /etc/default/tlp
sudo sed -i 's/^#CPU_SCALING_MAX_FREQ_ON_BAT=0/CPU_SCALING_MAX_FREQ_ON_BAT=2200000/g' /etc/default/tlp
sudo sed -i 's/^#CPU_SCALING_MIN_FREQ_ON_AC=0/CPU_SCALING_MIN_FREQ_ON_AC=2200000/g' /etc/default/tlp
sudo sed -i 's/^#CPU_SCALING_MAX_FREQ_ON_AC=0/CPU_SCALING_MAX_FREQ_ON_AC=4100000/g' /etc/default/tlp
