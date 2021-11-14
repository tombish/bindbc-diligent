/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
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

module bindbc.diligent.graphics.vulkan.enginefactoryvk;

/// \file
/// Declaration of functions that initialize Direct3D12-based engine implementation

import bindbc.diligent.graphics.enginefactory;
import bindbc.diligent.graphics.renderdevice;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.swapchain;

version(BindDiligent_Dynamic) { version(Windows) {
    import bindbc.diligent.graphics.loadenginedll;
    enum EXPLICITLY_LOAD_ENGINE_VK_DLL = 1;
}}

// {F554EEE4-57C2-4637-A508-85BE80DC657C}
static const INTERFACE_ID IID_EngineFactoryVk =
    INTERFACE_ID(0xf554eee4, 0x57c2, 0x4637, [0xa5, 0x8, 0x85, 0xbe, 0x80, 0xdc, 0x65, 0x7c]);

struct IEngineFactoryVkMethods
{
    /// Creates a render device and device contexts for Vulkan backend

    /// \param [in] EngineCI    - Engine creation attributes.
    /// \param [out] ppDevice   - Address of the memory location where pointer to
    ///                           the created device will be written
    /// \param [out] ppContexts - Address of the memory location where pointers to
    ///                           the contexts will be written. Immediate context goes at
    ///                           position 0. If EngineCI.NumDeferredContexts > 0,
    ///                           pointers to the deferred contexts are written afterwards.
    void* CreateDeviceAndContextsVk(IEngineFactoryVk*,
                                                   const(EngineVkCreateInfo)* EngineCI,
                                                   IRenderDevice**            ppDevice,
                                                   IDeviceContext**           ppContexts);

    /// Creates a swap chain for Vulkan-based engine implementation

    /// \param [in] pDevice           - Pointer to the render device
    /// \param [in] pImmediateContext - Pointer to the immediate device context.
    ///                                 Swap chain creation will fail if the context can not present to the window.
    /// \param [in] SCDesc            - Swap chain description
    /// \param [in] Window            - Platform-specific native window description that
    ///                                 the swap chain will be associated with.
    ///
    /// \param [out] ppSwapChain    - Address of the memory location where pointer to the new
    ///                               swap chain will be written
    void* CreateSwapChainVk(IEngineFactoryVk*,
                                           IRenderDevice*        pDevice,
                                           IDeviceContext*       pImmediateContext,
                                           const(SwapChainDesc)* SwapChainDesc,
                                           const(NativeWindow)*  Window,
                                           ISwapChain**          ppSwapChain);

    /// Enable device simulation layer (if available).

    /// Vulkan instance will be created with the device simulation layer.
    /// Use VK_DEVSIM_FILENAME environment variable to define the path to the .json file.
    /// 
    /// \remarks Use this function before calling EnumerateAdapters() and CreateDeviceAndContextsVk().
    void* EnableDeviceSimulation(IEngineFactoryVk*);
}

struct IEngineFactoryVkVtbl { IEngineFactoryVkMethods EngineFactoryVk; }
struct IEngineFactoryVk { IEngineFactoryVkVtbl* pVtbl; }

void* IEngineFactoryVk_CreateDeviceAndContextsVk(IEngineFactoryVk* engineFactory,
                                                   const(EngineVkCreateInfo)* engineCI,
                                                   IRenderDevice**            ppDevice,
                                                   IDeviceContext**           ppContexts) {
    return engineFactory.pVtbl.EngineFactoryVk.CreateDeviceAndContextsVk(engineFactory, engineCI, ppDevice, ppContexts);
}

void* IEngineFactoryVk_CreateSwapChainVk(IEngineFactoryVk* engineFactory,
                                           IRenderDevice*        pDevice,
                                           IDeviceContext*       pImmediateContext,
                                           const(SwapChainDesc)* swapchainDesc,
                                           const(NativeWindow)*  window,
                                           ISwapChain**          ppSwapChain) {
    return engineFactory.pVtbl.EngineFactoryVk.CreateSwapChainVk(engineFactory, pDevice, pImmediateContext, swapchainDesc, window, ppSwapChain);
}

void* IEngineFactoryVk_EnableDeviceSimulation(IEngineFactoryVk* engineFactory) {
    return engineFactory.pVtbl.EngineFactoryVk.EnableDeviceSimulation(engineFactory);
}

static if (EXPLICITLY_LOAD_ENGINE_VK_DLL) {
   IEngineFactoryVk* function() GetEngineFactoryVkType;

    GetEngineFactoryVkType Diligent_LoadGraphicsEngineVk()
    {
        return cast(GetEngineFactoryVkType)LoadEngineDll("GraphicsEngineVk", "GetEngineFactoryVk");
    } 
} else {    
    IEngineFactoryVk* Diliget_GetEngineFactoryVk();
}
