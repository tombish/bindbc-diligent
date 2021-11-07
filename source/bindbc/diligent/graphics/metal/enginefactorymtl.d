/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF ANY PROPRIETARY RIGHTS.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.metal.enginefactorymtl;

/// \file
/// Declaration of functions that initialize Vulkan-based engine implementation

import bindbc.diligent.graphics.enginefactory;
import bindbc.diligent.graphics.renderdevice;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.swapchain;

// {CF4A590D-2E40-4F48-9579-0D25991F963B}
static const INTERFACE_ID IID_EngineFactoryMtl =
    INTERFACE_ID(0xcf4a590d, 0x2e40, 0x4f48, [0x95, 0x79, 0xd, 0x25, 0x99, 0x1f, 0x96, 0x3b]);

struct ICommandQueueMtl;

struct IEngineFactoryMtlMethods
{
    /// Creates render device and device contexts for Metal-based engine implementation

    /// \param [in]  EngineCI   - Engine creation attributes.
    /// \param [out] ppDevice   - Address of the memory location where pointer to
    ///                           the created device will be written.
    /// \param [out] ppContexts - Address of the memory location where pointers to
    ///                           the contexts will be written. Immediate context goes at
    ///                           position 0. If EngineCI.NumDeferredContexts > 0,
    ///                           pointers to the deferred contexts go afterwards.
    void* CreateDeviceAndContextsMtl(IEngineFactoryMtl*,
                                                    const(EngineMtlCreateInfo)* EngineCI,
                                                    IRenderDevice**             ppDevice,
                                                    IDeviceContext**            ppContexts);

    /// Creates a swap chain for Metal-based engine implementation

    /// \param [in] pDevice      - Pointer to the render device.
    /// \param [in] pImmediateContext - Pointer to the immediate device context.
    /// \param [in] SCDesc       - Swap chain description.
    /// \param [in] Window       - Platform-specific native handle of the window.
    /// \param [out] ppSwapChain - Address of the memory location where pointer to the new
    ///                            swap chain will be written.
    void* CreateSwapChainMtl(IEngineFactoryMtl*,
                                            IRenderDevice*        pDevice,
                                            IDeviceContext*       pImmediateContext,
                                            const(SwapChainDesc)* SCDesc,
                                            const(NativeWindow)*  Window,
                                            ISwapChain**          ppSwapChain);

    /// Creates a command queue from Metal native command queue.
    
    /// \param [in]  pMtlNativeQueue  - Pointer to the native Metal command queue.
    /// \param [in]  pRawMemAllocator - Pointer to the raw memory allocator.
    ///                                 Must be same as EngineCreateInfo::pRawMemAllocator in the following AttachToMtlDevice() call.
    /// \param [out] ppCommandQueue   - Address of the memory location where pointer to the command queue will be written.
    void* CreateCommandQueueMtl(IEngineFactoryMtl*,
                                               void*              pMtlNativeQueue,
                                               IMemoryAllocator*  pRawAllocator,
                                               ICommandQueueMtl** ppCommandQueue);

    /// Attaches to existing Mtl render device and immediate context

    /// \param [in]  pMtlNativeDevice  - pointer to native Mtl device
    /// \param [in]  CommandQueueCount - Number of command queues.
    /// \param [in]  ppCommandQueues   - Pointer to the array of command queues.
    ///                                  Must be created from existing command queue using CreateCommandQueueMtl().
    /// \param [in]  EngineCI          - Engine creation attributes.
    /// \param [out] ppDevice          - Address of the memory location where pointer to
    ///                                  the created device will be written
    /// \param [out] ppContexts        - Address of the memory location where pointers to
    ///                                  the contexts will be written. Immediate context goes at
    ///                                  position 0. If EngineCI.NumDeferredContexts > 0,
    ///                                  pointers to the deferred contexts go afterwards.
    void* AttachToMtlDevice(IEngineFactoryMtl*,
                                           void*                       pMtlNativeDevice,
                                           uint                        CommandQueueCount,
                                           ICommandQueueMtl**          ppCommandQueues,
                                           const(EngineMtlCreateInfo)* EngineCI,
                                           IRenderDevice**             ppDevice,
                                           IDeviceContext**            ppContexts);
}

struct IEngineFactoryMtlVtbl { IEngineFactoryMtlMethods EngineFactoryMtl; }
struct IEngineFactoryMtl { IEngineFactoryMtlVtbl* pVtbl; }

void* IEngineFactoryMtl_CreateDeviceAndContextsMtl(IEngineFactoryMtl* factory,
                                                    const(EngineMtlCreateInfo)* engineCI,
                                                    IRenderDevice**             ppDevice,
                                                    IDeviceContext**            ppContexts) {
    return factory.pVtbl.EngineFactoryMtl.CreateDeviceAndContextsMtl(factory, engineCI, ppDevice, ppContexts);
}

void* IEngineFactoryMtl_CreateSwapChainMtl(IEngineFactoryMtl* factory,
                                            IRenderDevice*        pDevice,
                                            IDeviceContext*       pImmediateContext,
                                            const(SwapChainDesc)* swapChainDesc,
                                            const(NativeWindow)*  window,
                                            ISwapChain**          ppSwapChain) {
    return factory.pVtbl.EngineFactoryMtl.CreateSwapChainMtl(factory, pDevice, pImmediateContext, swapChainDesc, window, ppSwapChain);
}

void* IEngineFactoryMtl_CreateCommandQueueMtl(IEngineFactoryMtl* factory,
                                               void*              pMtlNativeQueue,
                                               IMemoryAllocator*  pRawAllocator,
                                               ICommandQueueMtl** ppCommandQueue) {
    return factory.pVtbl.EngineFactoryMtl.CreateCommandQueueMtl(factory, pMtlNativeQueue, pRawAllocator, ppCommandQueue);
}

void* IEngineFactoryMtl_AttachToMtlDevice(IEngineFactoryMtl* factory,
                                           void*                       pMtlNativeDevice,
                                           uint                        commandQueueCount,
                                           ICommandQueueMtl**          ppCommandQueues,
                                           const(EngineMtlCreateInfo)* engineCI,
                                           IRenderDevice**             ppDevice,
                                           IDeviceContext**            ppContexts) {
    return factory.pVtbl.EngineFactoryMtl.AttachToMtlDevice(factory, pMtlNativeDevice, commandQueueCount, ppCommandQueues, engineCI, ppDevice, ppContexts);
}

IEngineFactoryMtl* Diligent_GetEngineFactoryMtl();
