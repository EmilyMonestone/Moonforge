// Mobile Menu Toggle
const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
const navMenu = document.querySelector('.nav-menu');
const body = document.body;

if (mobileMenuToggle && navMenu) {
    mobileMenuToggle.addEventListener('click', () => {
        navMenu.classList.toggle('active');
        mobileMenuToggle.classList.toggle('active');
        
        // Prevent body scroll when menu is open
        if (navMenu.classList.contains('active')) {
            body.style.overflow = 'hidden';
        } else {
            body.style.overflow = '';
        }
    });

    // Close menu when clicking on a link
    const navLinks = navMenu.querySelectorAll('a');
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
            body.style.overflow = '';
        });
    });

    // Close menu when clicking outside
    document.addEventListener('click', (e) => {
        if (!navMenu.contains(e.target) && !mobileMenuToggle.contains(e.target)) {
            navMenu.classList.remove('active');
            mobileMenuToggle.classList.remove('active');
            body.style.overflow = '';
        }
    });
}

// Smooth Scrolling for Anchor Links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        
        // Don't prevent default for empty anchors
        if (href === '#' || href === '#!') {
            e.preventDefault();
            return;
        }
        
        const target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            const navbarHeight = document.querySelector('.navbar').offsetHeight;
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navbarHeight - 20;
            
            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});

// Navbar Background on Scroll
const navbar = document.querySelector('.navbar');
let lastScrollY = window.scrollY;

window.addEventListener('scroll', () => {
    const currentScrollY = window.scrollY;
    
    if (currentScrollY > 50) {
        navbar.style.background = 'rgba(10, 10, 15, 0.95)';
        navbar.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.5)';
    } else {
        navbar.style.background = 'rgba(10, 10, 15, 0.8)';
        navbar.style.boxShadow = 'none';
    }
    
    lastScrollY = currentScrollY;
});

// Intersection Observer for Fade-in Animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate-fade-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe elements that should fade in
const animateElements = document.querySelectorAll('.feature-card, .screenshot-card, .download-card, .faq-item, .roadmap-item');
animateElements.forEach(el => {
    observer.observe(el);
});

// Newsletter Form Handling
const newsletterForm = document.querySelector('.newsletter-form');
if (newsletterForm) {
    newsletterForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        const emailInput = newsletterForm.querySelector('input[type="email"]');
        const email = emailInput.value;
        
        // In a real application, you would send this to your backend
        console.log('Newsletter signup:', email);
        
        // Show success message (you can customize this)
        alert('Thank you for subscribing! We\'ll keep you updated on Moonforge news and releases.');
        emailInput.value = '';
    });
}

// Feature Card Hover Effect
const featureCards = document.querySelectorAll('.feature-card');
featureCards.forEach(card => {
    card.addEventListener('mouseenter', function() {
        this.style.transform = 'translateY(-8px)';
    });
    
    card.addEventListener('mouseleave', function() {
        this.style.transform = 'translateY(0)';
    });
});

// Download Button Click Tracking
const downloadButtons = document.querySelectorAll('.btn-download:not(.disabled)');
downloadButtons.forEach(button => {
    button.addEventListener('click', (e) => {
        const platform = button.closest('.download-card').querySelector('h3').textContent;
        console.log('Download clicked for:', platform);
        
        // In a real application, you would track this analytics event
        // and redirect to the actual download URL
        
        if (button.getAttribute('href') === '#') {
            e.preventDefault();
            alert(`Downloads for ${platform} will be available soon! Follow us on GitHub for updates.`);
        }
    });
});

// Parallax Effect for Hero Decoration
const heroDecoration = document.querySelector('.hero-decoration');
if (heroDecoration) {
    window.addEventListener('scroll', () => {
        const scrolled = window.pageYOffset;
        const parallaxSpeed = 0.5;
        heroDecoration.style.transform = `translateY(${scrolled * parallaxSpeed}px)`;
    });
}

// Keyboard Navigation Enhancement
document.addEventListener('keydown', (e) => {
    // ESC key closes mobile menu
    if (e.key === 'Escape' && navMenu && navMenu.classList.contains('active')) {
        navMenu.classList.remove('active');
        if (mobileMenuToggle) {
            mobileMenuToggle.classList.remove('active');
        }
        body.style.overflow = '';
    }
});

// Add loading state to primary CTA buttons
const ctaButtons = document.querySelectorAll('.btn-primary');
ctaButtons.forEach(button => {
    button.addEventListener('click', function(e) {
        // Add a subtle loading effect
        const originalText = this.innerHTML;
        
        // Only add loading state if it's not navigating to an anchor
        const href = this.getAttribute('href');
        if (href && !href.startsWith('#')) {
            this.style.opacity = '0.7';
            this.style.pointerEvents = 'none';
            
            setTimeout(() => {
                this.style.opacity = '1';
                this.style.pointerEvents = 'auto';
            }, 1000);
        }
    });
});

// Console Easter Egg
console.log('%c🌙 Welcome to Moonforge! 🎲', 'font-size: 20px; font-weight: bold; color: #a855f7;');
console.log('%cInterested in contributing? Check out our GitHub: https://github.com/EmilyMoonstone/Moonforge', 'font-size: 14px; color: #c084fc;');
console.log('%cMay your rolls be ever in your favor! 🎲✨', 'font-size: 14px; color: #7c3aed;');

// Performance Optimization: Debounce scroll events
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Apply debounce to scroll-heavy operations
const optimizedScroll = debounce(() => {
    // Any additional scroll-based operations can go here
}, 100);

window.addEventListener('scroll', optimizedScroll);

// Add viewport height CSS variable for mobile browsers
function setVH() {
    const vh = window.innerHeight * 0.01;
    document.documentElement.style.setProperty('--vh', `${vh}px`);
}

setVH();
window.addEventListener('resize', debounce(setVH, 250));

// Preload critical images (when they are added)
function preloadImages(urls) {
    urls.forEach(url => {
        const img = new Image();
        img.src = url;
    });
}

// Call this when you have actual images
// preloadImages(['./assets/img/hero-bg.png', './assets/img/feature-1.png']);

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    console.log('Moonforge website loaded successfully!');
    
    // Add fade-in to hero section
    const heroContent = document.querySelector('.hero-content');
    if (heroContent) {
        heroContent.classList.add('animate-fade-in');
    }
});
