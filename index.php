<?php
// Digital Code Lab - Apache Server Entrypoint
// Redirects root access directly to the production distribution build
if (file_exists(__DIR__ . '/dist/index.html')) {
    header('Location: dist/');
    exit;
} else {
    echo "<h1>Digital Code Lab</h1><p>Please run <code>npm run build</code> to generate the dist directory or run <code>npm run dev</code> for development mode.</p>";
}
?>
