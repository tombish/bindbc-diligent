# bindbc-diligent WIP

This project will provide both static and dynamic bindings to the [DiligentCore](https://github.com/DiligentGraphics/DiligentCore) library.

## TODO
* impliment if ENGINE_DLL sections of code enginefactoryd3d11.d, enginefactoryd3d12.d
* cpp code inside graphics/tools/dynamictrextureatlas.d, graphics/tools/buffersuballocator.d d3dbase/shaderresourcevariabled3d.d; ? Investigate
* Deal with #include <dxgi1_4.h> inside swpchaind3d12.d
* review loadenginedll.d

## Diligent C API Issues
* IDeviceContextVk_GetVkCommandBuffer missing from devicecontextvk.h

* GetVkVersion missing from renderdevicevk.h

* framebuffervk.h GetVkFramebuffer() has no parameters. Should it have IFramebufferVk* as param?

* renderpassvk.h VkRenderPassGetVkRenderPass() has no parameters. Should it have IRenderPassVk* as param?

* samplervk.h VkSamplerGetVkSampler() has no parameters. Should it have ISamplerVk* as param?