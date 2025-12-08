# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- No planned changes.

## [0.5.0] - 2024-12-09
### Changed
- **BREAKING**: Drop Ruby 2.7 support, require Ruby >= 3.1.0
- Upgrade to Ruby 3.3.8
- Upgrade to Rails 7.2.3
- Upgrade ActiveResource from 6.0.0 to 6.2.0
- Update development dependencies (RSpec 3.13, RuboCop 1.69, VCR 6.3, WebMock 3.24)

### Removed
- Remove reek dependency (compatibility issues with Ruby 3)

## [0.4.0] - 2022-04-15
### Changed
- Supported Rails 6.x (EOL Rails 5.2.x)

## [0.3.8] - 2021-6-17
### Changed
- Removed file type check and changed to support any formats such as TempFile

