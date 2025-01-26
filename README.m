# Prepare a zip file containing the HTML, JavaScript, and README documentation for submission.

import os
import zipfile

# Create folder structure for the project
project_path = "/mnt/data/Step2_Submission"
os.makedirs(project_path, exist_ok=True)

# HTML content for the encryption example
html_content = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public/Private Key Encryption</title>
</head>
<body>
    <h1>Public/Private Key Encryption Example</h1>
    <textarea id="message" placeholder="Enter your message"></textarea><br><br>
    <button id="encryptBtn">Encrypt</button>
    <p><strong>Encrypted Message:</strong></p>
    <pre id="encryptedMessage"></pre>
    <button id="decryptBtn">Decrypt</button>
    <p><strong>Decrypted Message:</strong></p>
    <pre id="decryptedMessage"></pre>

    <script src="script.js"></script>
</body>
</html>
"""

# JavaScript content for encryption and decryption using Web Crypto API
js_content = """
// Generate keys
let privateKey, publicKey;
(async function generateKeys() {
    const keyPair = await window.crypto.subtle.generateKey(
        {
            name: "RSA-OAEP",
            modulusLength: 2048,
            publicExponent: new Uint8Array([1, 0, 1]),
            hash: "SHA-256",
        },
        true,
        ["encrypt", "decrypt"]
    );
    publicKey = keyPair.publicKey;
    privateKey = keyPair.privateKey;
})();

document.getElementById("encryptBtn").onclick = async () => {
    const message = document.getElementById("message").value;
    const encodedMessage = new TextEncoder().encode(message);

    const encryptedMessage = await window.crypto.subtle.encrypt(
        {
            name: "RSA-OAEP",
        },
        publicKey,
        encodedMessage
    );

    document.getElementById("encryptedMessage").textContent = btoa(
        String.fromCharCode(...new Uint8Array(encryptedMessage))
    );
};

document.getElementById("decryptBtn").onclick = async () => {
    const encryptedMessage = atob(
        document.getElementById("encryptedMessage").textContent
    );
    const encryptedMessageBuffer = new Uint8Array(
        encryptedMessage.split("").map((char) => char.charCodeAt(0))
    );

    const decryptedMessage = await window.crypto.subtle.decrypt(
        {
            name: "RSA-OAEP",
        },
        privateKey,
        encryptedMessageBuffer
    );

    document.getElementById("decryptedMessage").textContent = new TextDecoder().decode(
        decryptedMessage
    );
};
"""

# Documentation for the project
readme_content = """
# Public/Private Key Encryption Example

This project demonstrates how public and private keys work for encryption and decryption using the Web Crypto API.

## Files Included
1. `index.html` - The main HTML file for the encryption example.
2. `script.js` - JavaScript code for encrypting and decrypting messages.
3. `README.md` - Documentation for the project.

## How It Works
1. The Web Crypto API generates a pair of keys (public and private).
2. The public key is used to encrypt a message entered by the user.
3. The private key is used to decrypt the encrypted message back into its original form.

## Steps to Run
1. Open `index.html` in any modern web browser.
2. Enter a message in the text area and click "Encrypt".
3. The encrypted message will be displayed.
4. Click "Decrypt" to retrieve the original message.

## Purpose
This project is designed for educational purposes to demonstrate the concept of public/private key encryption.

"""

# Write files to the project folder
with open(os.path.join(project_path, "index.html"), "w") as html_file:
    html_file.write(html_content)

with open(os.path.join(project_path, "script.js"), "w") as js_file:
    js_file.write(js_content)

with open(os.path.join(project_path, "README.md"), "w") as readme_file:
    readme_file.write(readme_content)

# Create a zip file for submission
zip_path = "/mnt/data/Step2_Submission.zip"
with zipfile.ZipFile(zip_path, "w") as zip_file:
    for root, dirs, files in os.walk(project_path):
        for file in files:
            zip_file.write(os.path.join(root, file), os.path.relpath(os.path.join(root, file), project_path))

zip_path
