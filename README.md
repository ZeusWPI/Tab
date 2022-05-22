# README

## Get started

1. Run `bundle`
2. Run `yarn`
3. Run `./bin/dev`
4. Browse to [http://localhost:3000](http://localhost:3000)


## Troubleshooting

### My CSS classes aren't rendered

This probably is a missing entry in Tailwinds configuration. Make sure your file path is included in the `content` array in `tailwind.config.js`.

When Tailwind compiles CSS, it scans all files matching the `content` array to know which CSS classes to include.
