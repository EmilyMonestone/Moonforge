# Moonforge Website

This directory contains the marketing and landing page for Moonforge, a multi-platform D&D campaign manager.

## Structure

```
website/
├── index.html              # Main landing page
├── assets/
│   ├── css/
│   │   └── styles.css      # Dark theme with purple accents
│   ├── js/
│   │   └── main.js         # Interactive features
│   └── img/
│       ├── favicon.svg     # Favicon
│       └── og-image.png    # Social media preview (placeholder SVG)
└── README.md              # This file
```

## Design

- **Theme**: Dark mode with purple (#a855f7) as the primary accent color
- **Typography**: System font stack for optimal performance
- **Layout**: Fully responsive, mobile-first design
- **Accessibility**: High contrast ratios, semantic HTML, keyboard navigation

## Features

### Sections
- **Hero**: Eye-catching introduction with primary CTA
- **Features**: Grid showcase of all major features (9 cards)
- **Screenshots**: Gallery with placeholders for future images
- **Download**: Platform-specific download buttons (Windows, macOS, Linux, Web, Android, iOS)
- **Roadmap**: Timeline showing development phases
- **FAQ**: Common questions and answers
- **Newsletter**: Email signup form
- **Footer**: Links, social icons, legal information

### Interactivity
- Smooth scrolling for anchor links
- Mobile-responsive navigation menu
- Fade-in animations on scroll
- Hover effects on interactive elements
- Parallax effect on hero section
- Keyboard navigation support

## Development

This is a static HTML website requiring no build process. Simply open `index.html` in a browser or serve it with any static file server.

### Local Development

Using Python:
```bash
cd website
python -m http.server 8000
```

Using Node.js:
```bash
cd website
npx serve
```

## Deployment

The website can be deployed to any static hosting service:
- GitHub Pages
- Netlify
- Vercel
- Firebase Hosting
- AWS S3 + CloudFront

## Future Enhancements

- [ ] Replace placeholder images with actual screenshots
- [ ] Add actual download links when releases are published
- [ ] Implement newsletter backend integration
- [ ] Add blog section for updates
- [ ] Create privacy policy and terms of service pages
- [ ] Add internationalization (i18n) support
- [ ] Implement analytics tracking
- [ ] Add testimonials section with user quotes
- [ ] Create video demo embed

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers (iOS Safari, Chrome Android)

## License

MIT License - See [LICENSE](../LICENSE) in the repository root.
