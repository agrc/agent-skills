---
name: "ugrc-upgrade-arcgis-v5"
description: "Upgrade the @arcgis/core package and related packages to v5"
---

Upgrade the packages in this project to work with the new v5 of the @arcgis/core package. Also upgrade any related packages that are needed to work with the new version.

If this project uses the @ugrc/utah-design-system package, make sure that it is upgraded to the latest version which is compatible with the new version of @arcgis/core.

Fetch and use the release notes for v5 from: #fetch https://developers.arcgis.com/javascript/latest/release-notes/.

Fetch and use this guide for migrating to components from: #fetch https://developers.arcgis.com/javascript/latest/migrating-to-components/

Clean up any `__esri.` type references and replace them with imported types.

If you see errors in the console about failure to create map layers you may need to add alias vite configurations similar to the following file #fetch https://raw.githubusercontent.com/agrc/atlas/refs/heads/main/vite.config.ts.
