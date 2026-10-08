# URL Full Page Capture

A small Termux project for capturing full-page PNG screenshots of websites using Chromium and `playwright-termux`.

The URL is intentionally stored directly in `capture.py`. Change the URL in the code before running the project.

## Features

- Runs directly in Termux on Android.
- Uses the Chromium package provided by Termux.
- Uses `playwright-termux` and Chromium CDP.
- Captures the complete page rather than only the visible viewport.
- Saves the result as `shot.png`.
- Includes a simple command to copy the screenshot to the Android Downloads folder.
- No command-line URL arguments are required.

## Project structure

```text
url-fullpage-capture/
├── capture.py
├── requirements.txt
├── run.sh
├── share-to-downloads.sh
├── setup-termux.sh
├── .gitignore
├── LICENSE
└── README.md
```

## Requirements

This project is intended for Termux on Android.

Required:

- Termux
- Python
- Chromium
- `playwright-termux` 2.0.0

The tested environment for this project used:

```text
Python 3.14
Chromium 152
playwright-termux 2.0.0
ARM64 Android
```

Other versions may work, but are not guaranteed.

## Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/url-fullpage-capture.git
cd termux-fullpage-capture
```

Run the setup script:

```bash
bash setup-termux.sh
```

Or install the components manually:

```bash
pkg update
pkg install python chromium
python -m pip install -r requirements.txt
```

## Change the URL

Open the Python file:

```bash
nano capture.py
```

Find:

```python
URL = "https://example.com"
```

Change it to the website you want to capture.

For example:

```python
URL = "https://www.wikipedia.org/"
```

Save the file.

The project intentionally does not accept the URL from the command line. The URL is changed directly in the source code.

## Run

After the initial setup, the normal command is simply:

```bash
./run.sh
```

The screenshot will be created as:

```text
shot.png
```

You can also run the Python file directly:

```bash
python capture.py
```

## Copy the screenshot to Android Downloads

First, allow Termux to access shared Android storage:

```bash
termux-setup-storage
```

After Android grants permission, run:

```bash
./share-to-downloads.sh
```

The file will be copied to:

```text
~/storage/downloads/shot.png
```

This corresponds to the Android Downloads folder.

You can also perform the copy manually:

```bash
cp shot.png ~/storage/downloads/shot.png
```

## Complete first-time setup

After cloning, the basic sequence is:

```bash
cd termux-fullpage-capture
bash setup-termux.sh
termux-setup-storage
```

Then change the URL:

```bash
nano capture.py
```

Run:

```bash
./run.sh
```

Copy the result to Android Downloads:

```bash
./share-to-downloads.sh
```

## How full-page capture works

The official Playwright Python API normally provides:

```python
page.screenshot(path="shot.png", full_page=True)
```

`playwright-termux` 2.0.0 does not expose the `full_page` argument.

This project therefore uses the Chromium DevTools Protocol through the session exposed by `playwright-termux`.

The script:

1. Opens Chromium in headless mode.
2. Creates a browser page.
3. Navigates to the configured URL.
4. Requests the page layout metrics through CDP.
5. Reads the complete content width and height.
6. Calls `Page.captureScreenshot`.
7. Enables `captureBeyondViewport`.
8. Decodes the returned base64 PNG data.
9. Writes the image to `shot.png`.

The important CDP calls are:

```python
metrics = page.session.send("Page.getLayoutMetrics")
```

and:

```python
page.session.send(
    "Page.captureScreenshot",
    {
        "format": "png",
        "captureBeyondViewport": True,
        "fromSurface": True,
        ...
    },
)
```

## Output

By default:

```text
shot.png
```

The file is created in the project directory.

The output is a PNG image containing the full page captured by Chromium.

## Changing the output filename

Edit:

```python
OUTPUT_FILE = "shot.png"
```

For example:

```python
OUTPUT_FILE = "website.png"
```

If you change the output filename, also change the filename expected by `share-to-downloads.sh`, or edit that script accordingly.

## Troubleshooting

### `No module named playwright_termux`

Install the dependency:

```bash
python -m pip install -r requirements.txt
```

### Chromium is not found

Install Chromium:

```bash
pkg install chromium
```

Check it:

```bash
chromium-browser --version
```

### Shared Downloads directory does not exist

Run:

```bash
termux-setup-storage
```

Then verify:

```bash
ls ~/storage/downloads
```

### Screenshot is not created

Run the Python script directly so that the complete error is visible:

```bash
python capture.py
```

### Website does not load correctly

Some websites require JavaScript, authentication, cookies, location services, or other browser features. This project does not automatically handle authentication or bypass access controls.

### Very large pages

Extremely long or complex pages can require substantial memory when Chromium creates a full-page screenshot. Android may terminate Chromium if the device runs low on memory.

## Notes

This project uses:

```text
playwright-termux==2.0.0
```

It is not the official `playwright` Python package.

The Termux package exposes a smaller API and communicates with Chromium through Chrome DevTools Protocol (CDP).

The code in this repository is written specifically for that API.

## License

MIT
