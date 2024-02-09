
print out aws ami for given Ubuntu release using terraform

do not run     tf apply     or this will actually create a aws EC2 virtual machine

pick which    Ubuntu release   by editing file

    main.tf

change variable  VERSION  in file  main.tf to pick desired Ubuntu release ... then issue


    tf init

    tf plan  


above   tf plan    will generate output similar to below which shows latest ami based on criteria in main.tf :



    Changes to Outputs:
      + image_id           = "ami-07d9b9ddc6cd8dd30"
      + ubuntu_server_name = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240207.1"



