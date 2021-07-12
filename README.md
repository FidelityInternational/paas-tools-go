# PaaS Tools

A set of tools useful for Concourse jobs that need golang

After issues with upstream projects, where using an image with go 1.16.x caused failures, we have decided to create a secondary master branch where we can update 2.0.x images without breaking things that use the latest master image.

- master: This will be used for image changes from 2.1.x onwards, using go version 1.16+
- master_2_0_0: This will be a legacy branch to update 2.0.x images that use 1.15, allowing us to have autobuilds without reverting/downgrading the image on master branch which some projects rely on.
