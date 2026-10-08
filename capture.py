from playwright_termux import Chromium
import base64


# Change this URL before running the script.
URL = "https://example.com"

# Screenshot filename.
OUTPUT_FILE = "shot.png"


def capture_full_page(url, output_path):
    with Chromium(headless=True) as browser:
        page = browser.new_page()

        page.goto(url)
        page.wait_for_timeout(1000)

        metrics = page.session.send("Page.getLayoutMetrics")
        content_size = metrics["contentSize"]

        width = int(content_size["width"])
        height = int(content_size["height"])

        result = page.session.send(
            "Page.captureScreenshot",
            {
                "format": "png",
                "captureBeyondViewport": True,
                "fromSurface": True,
                "clip": {
                    "x": 0,
                    "y": 0,
                    "width": width,
                    "height": height,
                    "scale": 1,
                },
            },
        )

        with open(output_path, "wb") as image_file:
            image_file.write(base64.b64decode(result["data"]))

    return output_path


if __name__ == "__main__":
    print(capture_full_page(URL, OUTPUT_FILE))
