---
toc: true
layout: api
---

# seL4 Project Roadmap

Below tables list our plans for various parts of seL4 and Data61-supported parts of its ecosystem.


Where we indicate that the feature will appear in <em>master</em>, it might possibly appear in a branch earlier.  Features in <em>branches</em> will be merged into mainline at a later time, timing of this is determined by the verification schedule. The reason is our commitment to ensuring that at any time, mainline code for our <em>verified</em> platforms is actually verified. This means that a feature can only be pushed into mainline if it doesn't break the verified platform proofs. In some cases this is no problem, e.g. as long as we haven't completed verification of x86, then changes that only affect x86 can go into mainline (as long as the verifiers agree that they will not inhibit future verification). This is the main reason why the real-time scheduling features will remain in a branch for some time &ndash; they are relatively invasive and break many existing proofs.

Some features are in branches because they are of an experimental nature, and are released to the community to allow people to experiment with them, we will do the same. This means that such experimental branches may undergo significant changes on their way into mainline, if they ever make it there.

Features that are <em>in progress</em> are currently being worked on, features that are <em>planned</em> have not yet had work started on them.

**Any dates are indicative and subject to change!**

In many cases, we could possibly deliver earlier if we had enough people to do the work. If our recruiting is more successful than expected, we might be able to go faster. If you want to help accelerate this roadmap, help us to find the right developers!

## seL4 Development

{% include component_list.md project='sel4' list='roadmap' type='in-progress' %}


## Verification

{% include component_list.md project='l4v' list='roadmap' type='in-progress' %}
