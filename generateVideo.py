import cv2
import os
import argparse


def resize_image(image, target_width, target_height):
    """
    Resize an image to fit within the specified dimensions while maintaining the original aspect ratio.
    """
    original_height, original_width = image.shape[:2]
    aspect_ratio = original_width / original_height

    if original_width > original_height:
        new_width = target_width
        new_height = int(target_width / aspect_ratio)
    else:
        new_height = target_height
        new_width = int(target_height * aspect_ratio)

    resized_image = cv2.resize(image, (new_width, new_height))

    # If the new dimensions are smaller in any direction, pad the resized image with black color
    top_padding = (target_height - new_height) // 2
    bottom_padding = target_height - new_height - top_padding
    left_padding = (target_width - new_width) // 2
    right_padding = target_width - new_width - left_padding

    return cv2.copyMakeBorder(
        resized_image,
        top_padding, bottom_padding, left_padding, right_padding,
        cv2.BORDER_CONSTANT, value=[0, 0, 0]
    )


def images_to_video(image_folder, output_video_file, fps=24, target_width=1920, target_height=1080):
    images = [img for img in os.listdir(image_folder) if img.lower().endswith((".png", ".jpg", ".jpeg"))]
    images.sort()

    out = cv2.VideoWriter(output_video_file, cv2.VideoWriter_fourcc(*'mp4v'), fps, (target_width, target_height))

    for image in images:
        img_path = os.path.join(image_folder, image)
        img = cv2.imread(img_path)

        if img is None:
            print(f"Failed to read: {img_path}")
            continue

        resized_img = resize_image(img, target_width, target_height)
        out.write(resized_img)

    out.release()
    print(f"Video saved to {output_video_file}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert images in a folder to a video.")
    parser.add_argument("image_folder", help="Path to the folder containing images")
    parser.add_argument("output_video", help="Output video filename (e.g., output.mp4)")
    parser.add_argument("--fps", type=int, default=24, help="Frames per second (default: 24)")
    parser.add_argument("--width", type=int, default=1920, help="Target video width (default: 1920)")
    parser.add_argument("--height", type=int, default=1080, help="Target video height (default: 1080)")

    args = parser.parse_args()

    images_to_video(args.image_folder, args.output_video, args.fps, args.width, args.height)
