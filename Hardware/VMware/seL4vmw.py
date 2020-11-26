#!/usr/bin/python3
#
# Copyright 2020 seL4 Project a Series of LF Projects, LLC.
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Xi (Ma) Chen, xima.chen@nicta.com.au

import os, sys, subprocess, random, time

## Configuration

vm_num = 4
vm_name = 'seL4vmw'
vm_gui = False if not "-gui" in sys.argv else True;
vm_leave_on = False;

## Variables

vm_dirname = ''
vm_dir = ''
vmx_file = ''
vmdk_file = ''
vcom_file = ''

print ("seL4 VMWare Development Environment Script");

## Functions

def xc(cmd, allow_fail = False):
    ret = os.system(cmd);
    if ret != 0 and allow_fail == False:
        print("### ERROR: command %s failed. Exiting." % cmd);
        sys.exit(1);

def x(cmd): return os.popen(cmd).read()

def VMfind():
    rlist = x("vmrun -T player list");
    for rline in rlist.splitlines():
        if rline.strip() == vmx_file.strip():
            return True;
    return False;

def VMfindfree():
    if len(sys.argv) <= 3:
        print("#### WARNING #### VM number not set. Using a random one.");
        print("#### WARNING #### You may run into conflicts with other people using it.");
        return random.SystemRandom().randint(0, vm_num - 1)
    return int(sys.argv[3]);

def VMoff():
    if vm_leave_on: return;
    if VMfind():
        print("shutting down VM %s" % vm_dirname);
        xc("vmrun -T player stop %s hard" % vmx_file);
        print("waiting 2 seconds for VM to close...");
        time.sleep(2);
        VMoff();
        return;
    print ("%s not running. OK." % vm_dirname);

def VMon():
    print ("Starting VM %s ....." % vm_dirname);
    if VMfind():
        xc("vmrun -T player reset %s %s" % (vmx_file, '' if vm_gui else 'nogui'));
    else:
        xc("vmrun -T player start %s %s" % (vmx_file, '' if vm_gui else 'nogui'));

## Main

kernel_image = sys.argv[1].strip();
init_image = sys.argv[2].strip();
mnt_dir = '/tmp/%s_mount_%s/' % (vm_dirname, random.SystemRandom().randint(10000, 99999));

def main():
    # Check VMWare installations and print usage.
    if len(sys.argv) < 3:    
        print ("\nChecking VMWare installations...");
        print ("    This script needs you to install VMWare Workstation.");
        print ("    Alternatively you may install VMWare Player and VIX separately manually.");    
        print ("    Tested on Workstation 10, Player 6.0.0, VIX 1.13.");    
        xc("vmplayer -v");
        xc("vmrun | head -n 2 | tail -n 1");
        xc("vmrun -T player list");
        print ("OK to go.\n");
        print ("\tusage: seL4vmw KERNEL_IMAGE INIT_IMAGE\n");
        sys.exit();

    # Set variables.
    global vm_dirname, vm_dir, vmx_file, vmdk_file, vcom_file;
    vm_dirname = 'seL4vmw%d' % (VMfindfree());
    vm_dir = '/lh/ertos-vm/%s/' % vm_dirname;
    vmx_file = vm_dir + ('%s.vmx' % vm_name);
    vmdk_file = vm_dir + ('%s-1.vmdk' % vm_name);
    vcom_file = vm_dir + ('%s-COM1.txt' % vm_name);

    print ("    KERNEL_IMAGE = [%s]" % kernel_image);
    print ("    INIT_IMAGE = [%s]" % init_image);
    print ("    MNT_DIR = [%s]" % mnt_dir);
    
    # Turn off any previous VMs.
    VMoff();
    
    # Copy the files into VMDK.
    if vm_leave_on == False:
        xc('rm -rf %s > /dev/null' % mnt_dir, True);
        xc('mkdir %s' % mnt_dir);
        xc('vmware-mount %s %s' % (vmdk_file, mnt_dir));
        xc('sudo cp %s %s/' % (kernel_image, mnt_dir));
        xc('sudo cp %s %s/' % (init_image, mnt_dir));
        xc('vmware-mount -d %s' % mnt_dir);

    # Run the VM.
    x("rm -f %s" % vcom_file);
    VMon();

    print("waiting 1 seconds for VM to boot...");
    time.sleep(1);
    #xc('less -r +F %s' % vcom_file, True);
    xc('tail -F %s' % vcom_file, True);

    VMoff();
    xc('rm -rf %s' % mnt_dir, True);

try:
    main();
except (KeyboardInterrupt, SystemExit):
    print ('Ctrl + C recieved, shutting down VM ... (Please dont Ctrl+C this Ctrl+C).');
    VMoff();
    xc('vmware-mount -d %s > /dev/null' % mnt_dir, True);
    xc('rm -rf %s > /dev/null' % mnt_dir, True);

