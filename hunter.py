import argparse

parser = argparse.ArgumentParser(description='Use this program to interact with Velociraptor and ELK Infrastructure.')
group = parser.add_mutually_exclusive_group()
group.add_argument('-b', '--build', action='store_true', help='Build infrastructure')
group.add_argument( '-c', '--connect', action='store_true', help='Connect to your infrastructure')
group.add_argument('-a', '--auth', action='store_true', help='Set Velocirpator Username and Password')
group.add_argument('-d', '--destroy', action='store_true', help='Build infrastructure')
args = parser.parse_args()

#Set Velociraptor Username and Password (interactive)
def set_vr_uname_pword():
    print("Set VR UNAME PWORD Function")
    return


#Deploy infrastructure 
def deploy_infra():
    print("Deploy infra Function")
    return


#Connect to infrastructure
def connect_infra():
    print("connect to infra Function")
    return


#Destroy infrastructure
def destroy_infra():
    print("Destroy infra function")
    return

if __name__ == "__main__":
    if args.build:
        deploy_infra()
    elif args.connect:
        connect_infra()
    elif args.auth:
        set_vr_uname_pword()
    elif args.destroy:
        destroy_infra()
    else:
        print(parser.print_help())