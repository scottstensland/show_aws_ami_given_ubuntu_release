
#  ... typical thing to change is below value of  VERSION to determine desired Ubuntu release
#  ... this code does a lookup to display aws ami driven from this choice 

variable "VERSION" {
  # default = "24.04"
  # default = "23.04"
  # default = "22.10"
  default = "22.04"
  # default = "20.04"
  # default = "18.04"
  # default = "16.04"
}


# ........  change aws region here as needed

variable "aws_region" { default = "us-east-1" }
# variable "aws_region" { default = "eu-east-1" }


variable "ARCH" {
  default = "amd64"
  # default = "arm64"
}



# ...  rarely change anything below  ... 


variable "FAMILY" {
  default = "ubuntu"
  # default = "ubuntu-minimal"
  # default = "ubuntu-pro-server"
  # default = "ubuntu-eks"
}

variable "RELEASE_STREAM" {
  default = "images"
  # default = "images-testing"
}

variable "VIRT" {
  default = "hvm"
}

# ... current code ignores    SUITE  ... I keep this here in case you wish to twerk below code to ask a different question

variable "SUITE" {
  default = "lunar"
  # default = "kinetic"
  # default = "jammy"
  # default = "focal"
  # default = "bionic"
  # default = "xenial"
}



variable "ubuntu_map" {    #  not used in this incantation  ...  here to allow change question

  type = map(string)

  default = {

    "lunar"   = "23.04"
    "kinetic" = "22.10"
    "jammy"   = "22.04"
    "focal"   = "20.04"
    "bionic"  = "18.04"
    "xenial"  = "16.04"
  }
}



variable "ubuntu_map_n2v" {

  type = map(string)

  default = {

    "23.04" = "lunar"
    "22.10" = "kinetic"
    "22.04" =  "jammy" 
    "20.04" = "focal" 
    "18.04" = "bionic" 
    "16.04" = "xenial" 
  }
}



#  ${FAMILY}/${RELEASE_STREAM}/${VIRT}-${STORAGE}/ubuntu-${SUITE}-${VERSION}-${ARCH}-server-${SERIAL}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"

    # values = ["${FAMILY}/${RELEASE_STREAM}/${VIRT}-ssd/ubuntu-${SUITE}-${VERSION}-${ARCH}-server-*"]
    # values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.VERSION}-${var.ARCH}-server-*"]
    # values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.ubuntu_map[${var.SUITE}]}-${var.ARCH}-server-*"]
    # values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.ubuntu_map[var.SUITE]}-${var.ARCH}-server-*"]
    # values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.ubuntu_map[${var.SUITE}]}-${var.ARCH}-server-*"]
	# values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.VERSION}-${var.ARCH}-server-*"]

	// below runs fine   jammy  --> 22.04
	// values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.SUITE}-${var.ubuntu_map["${var.SUITE}"]}-${var.ARCH}-server-*"]

	// below using map   ubuntu_map_n2v    22.04 --> jammy
	// values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${var.ubuntu_map_n2v["${var.VERSION}"]}-${var.VERSION}-${var.ARCH}-server-*"]

	// ... use tf function lookup 
	values = ["${var.FAMILY}/${var.RELEASE_STREAM}/${var.VIRT}-ssd/ubuntu-${lookup(var.ubuntu_map_n2v, var.VERSION, "invalid_lookup")}-${var.VERSION}-${var.ARCH}-server-*"]
	}

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical  this limits ami to ONLY those provided by this owner  Ubuntu is 099720109477
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "show_aws_ami"
  }
}

