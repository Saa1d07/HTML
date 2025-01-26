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
