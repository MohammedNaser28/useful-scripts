#!/usr/bin/env zx

// #!/usr/bin/env zx

// Ask user for a note
const note = await question("📝 Write your note: ");

// Get today's date (YYYY-MM-DD)
const date = new Date().toISOString().split("T")[0];
const filename = `notes-${date}.md`;

// If file doesn't exist, create it with a header
if (!fs.existsSync(filename)) {
  await fs.promises.writeFile(filename, `# Notes for ${date}\n\n`);
}

// Append note with timestamp
const time = new Date().toLocaleTimeString();
await fs.promises.appendFile(filename, `- [${time}] ${note}\n`);

console.log(`✅ Note saved to ${filename}`);

