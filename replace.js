const fs = require('fs');

// Read config file
const config = fs.readFileSync('product.config', 'utf8');
let html = fs.readFileSync('index.html', 'utf8');

// Parse config
const vars = {};
config.split('\n').forEach(line => {
    const match = line.match(/^([A-Z_0-9]+)="(.*)"/);
    if (match) {
        vars[match[1]] = match[2];
    }
});

// Replace all placeholders
Object.keys(vars).forEach(key => {
    const placeholder = `{{${key}}}`;
    html = html.split(placeholder).join(vars[key]);
});

fs.writeFileSync('index.html', html);
console.log('Replacements done. Remaining placeholders:');
const remaining = (html.match(/\{\{[A-Z_0-9]+\}\}/g) || []);
console.log(remaining.length + ' placeholders remaining');
if (remaining.length > 0 && remaining.length < 20) {
    console.log(remaining);
}
