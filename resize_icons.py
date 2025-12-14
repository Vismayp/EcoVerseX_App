from PIL import Image
import os

def resize_and_save_icons():
    # Path to the source logo
    logo_path = r"D:\Maths\Ecoverse\logo.png"

    # Android icon sizes and their corresponding mipmap directories
    icon_sizes = {
        48: "mipmap-mdpi",
        72: "mipmap-hdpi",
        96: "mipmap-xhdpi",
        144: "mipmap-xxhdpi",
        192: "mipmap-xxxhdpi"
    }

    # Base path for Android resources
    android_res_path = r"D:\Maths\Ecoverse\EcoVerseX_App\android\app\src\main\res"

    try:
        # Open the logo image
        logo = Image.open(logo_path)
        print(f"✅ Loaded logo: {logo.size} pixels")

        # Process each icon size
        for size, folder in icon_sizes.items():
            # Create the full path for the mipmap directory
            mipmap_path = os.path.join(android_res_path, folder)

            # Ensure the directory exists
            os.makedirs(mipmap_path, exist_ok=True)

            # Resize the image (maintain aspect ratio, but force square)
            resized = logo.resize((size, size), Image.Resampling.LANCZOS)

            # Save the icon
            icon_path = os.path.join(mipmap_path, "ic_launcher.png")
            resized.save(icon_path, "PNG")

            print(f"✅ Created: {icon_path} ({size}x{size})")

        print("\n🎉 All EcoVerseX launcher icons created successfully!")
        print("You can now build your app with: flutter build apk")

    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    resize_and_save_icons()