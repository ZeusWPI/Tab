module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './app/javascript/**/*.jsx',
  ],
  theme: {
    extend: {
      keyframes: {
        wiggle: {
          '0%': { transform: 'rotate(0deg)' },
          '5%': { transform: 'rotate(-10deg) scale(1.1)' },
          '50%': { transform: 'rotate(10deg) scale(0.8)' },
          '100%': { transform: 'rotate(0deg)' },
        },
      },
      animation: {
        wiggle: 'wiggle 1s ease-in-out',
      },
    }
  }
}
