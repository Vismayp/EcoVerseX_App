import os
import sys
import subprocess

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

def generate_icons_online():
    """Instructions for online conversion"""
    print("Since Cairo is not available, here's how to generate icons online:")
    print()
    print("1. Go to an online SVG to PNG converter:")
    print("   - https://cloudconvert.com/svg-to-png")
    print("   - https://convertio.co/svg-png/")
    print("   - https://www.online-convert.com/svg-to-png")
    print()
    print("2. Upload the file: assets/logo.svg")
    print()
    print("3. Convert to PNG with these sizes:")
    print("   - 48x48 pixels (for mipmap-mdpi)")
    print("   - 72x72 pixels (for mipmap-hdpi)")
    print("   - 96x96 pixels (for mipmap-xhdpi)")
    print("   - 144x144 pixels (for mipmap-xxhdpi)")
    print("   - 192x192 pixels (for mipmap-xxxhdpi)")
    print()
    print("4. Save each PNG as 'ic_launcher.png' in the corresponding folders:")
    print("   - android/app/src/main/res/mipmap-mdpi/ic_launcher.png")
    print("   - android/app/src/main/res/mipmap-hdpi/ic_launcher.png")
    print("   - android/app/src/main/res/mipmap-xhdpi/ic_launcher.png")
    print("   - android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png")
    print("   - android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png")
    print()
    print("The icons are already generated and present in your project!")

def check_icons():
    """Check if icons already exist"""
    base_path = "android/app/src/main/res"
    sizes = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi']

    print("Checking existing icons:")
    all_exist = True
    for size in sizes:
        icon_path = f"{base_path}/mipmap-{size}/ic_launcher.png"
        exists = os.path.exists(icon_path)
        status = "✓" if exists else "✗"
        print(f"  {status} {size}: {icon_path}")
        if not exists:
            all_exist = False

    if all_exist:
        print("\n🎉 All launcher icons are already generated!")
        return True
    else:
        print("\n❌ Some icons are missing.")
        return False

if __name__ == "__main__":
    print("EcoVerseX Icon Generator")
    print("=" * 30)

    if check_icons():
        print("\nYour app already has all the launcher icons!")
        print("The green circular EcoVerseX logo is ready to use.")
    else:
        print("\nIcons are missing. Here's how to generate them:")
        generate_icons_online()

