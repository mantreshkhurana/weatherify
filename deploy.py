import os

agree = input("Do you want to deploy? (y/n): ")
if agree == "y":
    print("Deploying...")
    os.system("flutter clean")
    os.system("flutter pub get")
    os.system("flutter build web --release")
    os.system("firebase deploy")
    print("Deployed!")
else:
    print("Canceled!")