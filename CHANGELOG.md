## [0.0.5](https://github.com/dergachev/vagrant/compare/v0.0.4...v0.0.5) (Dec 10, 2013)

FEATURES:

  - Added 'vgrnt np' support.

IMPROVEMENTS:

  - Refactored codebase a bit:
    - Extracted shelling out logic into Vgrnt::Util::Exec
    - Extracted logger helpers into Vgrnt::Util::Logger
    - Improved Vgrnt::Util::Exec to allow capturing of stderr for testing

## [0.0.4](https://github.com/dergachev/vagrant/compare/v0.0.3...v0.0.4) (Dec 3, 2013)

BUGFIX:

  - Fix `vgrnt ssh` hanging due to improper shellout technique.

FEATURES:

  - Added support for `vgrnt status`

IMPROVEMENTS:

  - Refactored codebase a bit
  - Implemented acceptance tests (unit tests still non-existant)

## [0.0.3](https://github.com/dergachev/vagrant/compare/v0.0.2...v0.0.3) (Nov 12, 2013)

FEATURES:

  - Added support for `vgrnt status`

IMPROVEMENTS:

  - Refactored codebase a bit
  - Implemented acceptance tests (unit tests still non-existant)

## [0.0.2](https://github.com/dergachev/vagrant/compare/v0.0.1...v0.0.2) (Oct 30, 2013)

BUGFIX:

  - Further improved ssh_info regex. Now works when "VBoxManage showvminfo" outputs: Forwarding(1)="ssh,tcp,,2222,,22"

## [0.0.1](https://github.com/dergachev/vgrnt/commits/v0.0.1) (Oct 30, 2013)

BACKWARDS INCOMPATIBILITIES:

  - none

FEATURES:

  - Initial release

IMPROVEMENTS:

  - none
