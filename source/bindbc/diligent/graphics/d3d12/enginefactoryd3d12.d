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

module bindbc.diligent.graphics.d3d12.enginefactoryd3d12;

/// \file
/// Declaration of functions that initialize Direct3D12-based engine implementation

import bindbc.diligent.graphics.enginefactory;
import bindbc.diligent.graphics.renderdevice;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.swapchain;

version(BindDiligent_Dynamic) { import bindbc.diligent.graphics.loadenginedll; }

struct ICommandQueueD3D12;

// {72BD38B0-684A-4889-9C68-0A80EC802DDE}
static const INTERFACE_ID IID_EngineFactoryD3D12 =
    INTERFACE_ID(0x72bd38b0, 0x684a, 0x4889, [0x9c, 0x68, 0xa, 0x80, 0xec, 0x80, 0x2d, 0xde]);

/// Engine factory for Direct3D12 rendering backend
struct IEngineFactoryD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Loads D3D12 DLL and entry points.

        /// \param [in] DllName - D3D12 dll name.
        /// \return               true if the library and entry points are loaded successfully and false otherwise.
        ///
        /// \remarks IEngineFactoryD3D12::CreateDeviceAndContextsD3D12() and
        ///          IEngineFactoryD3D12::AttachToD3D12Device() functions will automatically
        ///          load the DLL if it has not be loaded already.
        ///
        ///          This method has no effect on UWP.
        bool* LoadD3D12(IEngineFactoryD3D12*, const(char)* DllName = "d3d12.dll");

        /// Creates a render device and device contexts for Direct3D12-based engine implementation.

        /// \param [in] EngineCI    - Engine creation info.
        /// \param [out] ppDevice   - Address of the memory location where pointer to
        ///                           the created device will be written.
        /// \param [out] ppContexts - Address of the memory location where pointers to
        ///                           the contexts will be written. Immediate context goes at
        ///                           position 0. If EngineCI.NumDeferredContexts > 0,
        ///                           pointers to the deferred contexts are written afterwards.
        void* CreateDeviceAndContextsD3D12(IEngineFactoryD3D12*,
                                                          const(EngineD3D12CreateInfo)* EngineCI,
                                                          IRenderDevice**                 ppDevice,
                                                          IDeviceContext**                ppContexts);

        /// Creates a command queue from Direct3D12 native command queue.

        /// \param [in]  pd3d12NativeDevice - Pointer to the native Direct3D12 device.
        /// \param [in]  pd3d12NativeDevice - Pointer to the native Direct3D12 command queue.
        /// \param [in]  pRawMemAllocator   - Pointer to the raw memory allocator.
        ///                                   Must be the same as EngineCreateInfo::pRawMemAllocator in the following AttachToD3D12Device() call.
        /// \param [out] ppCommandQueue     - Address of the memory location where pointer to the command queue will be written.
        void* CreateCommandQueueD3D12(IEngineFactoryD3D12*,
                                                     void*                   pd3d12NativeDevice,
                                                     void*                   pd3d12NativeCommandQueue,
                                                     IMemoryAllocator*       pRawMemAllocator,
                                                     ICommandQueueD3D12**    ppCommandQueue);

        /// Attaches to existing Direct3D12 device.

        /// \param [in] pd3d12NativeDevice - Pointer to the native Direct3D12 device.
        /// \param [in] CommandQueueCount  - Number of command queues.
        /// \param [in] ppCommandQueues    - Pointer to the array of command queues.
        ///                                  Must be created from existing command queue using CreateCommandQueueD3D12().
        /// \param [in] EngineCI           - Engine creation info.
        /// \param [out] ppDevice          - Address of the memory location where pointer to
        ///                                  the created device will be written
        /// \param [out] ppContexts - Address of the memory location where pointers to
        ///                           the contexts will be written. Immediate context goes at
        ///                           position 0. If EngineCI.NumDeferredContexts > 0,
        ///                           pointers to the deferred contexts are written afterwards.
        void* AttachToD3D12Device(IEngineFactoryD3D12*,
                                                 void*                           pd3d12NativeDevice,
                                                 Uint32                          CommandQueueCount,
                                                 ICommandQueueD3D12**            ppCommandQueues,
                                                 const(EngineD3D12CreateInfo)*   EngineCI,
                                                 IRenderDevice**                 ppDevice,
                                                 IDeviceContext**                ppContexts);

        /// Creates a swap chain for Direct3D12-based engine implementation.

        /// \param [in] pDevice           - Pointer to the render device.
        /// \param [in] pImmediateContext - Pointer to the immediate device context.
        ///                                 Only graphics contexts are supported.
        /// \param [in] SCDesc            - Swap chain description.
        /// \param [in] FSDesc            - Fullscreen mode description.
        /// \param [in] Window            - Platform-specific native window description that
        ///                                 the swap chain will be associated with:
        ///                                 * On Win32 platform, this is the window handle (HWND)
        ///                                 * On Universal Windows Platform, this is the reference
        ///                                   to the core window (Windows::UI::Core::CoreWindow)
        ///
        /// \param [out] ppSwapChain    - Address of the memory location where pointer to the new
        ///                               swap chain will be written
        void* CreateSwapChainD3D12(IEngineFactoryD3D12*,
                                                  IRenderDevice*               pDevice,
                                                  IDeviceContext*              pImmediateContext,
                                                  const(SwapChainDesc)*        SwapChainDesc,
                                                  const(FullScreenModeDesc)*   FSDesc,
                                                  const(NativeWindow)*         Window,
                                                  ISwapChain**                 ppSwapChain);

        /// Enumerates hardware adapters available on this machine.

        /// \param [in]     MinFeatureLevel - Minimum required feature level.
        /// \param [in,out] NumAdapters - Number of adapters. If Adapters is null, this value
        ///                               will be overwritten with the number of adapters available
        ///                               on this system. If Adapters is not null, this value should
        ///                               contain maximum number of elements reserved in the array
        ///                               pointed to by Adapters. In the latter case, this value
        ///                               is overwritten with the actual number of elements written to
        ///                               Adapters.
        /// \param [out]    Adapters - Pointer to the array conataining adapter information. If
        ///                            null is provided, the number of available adapters is written to
        ///                            NumAdapters
        ///
        /// \note           D3D12 must be loaded before this method can be called, see IEngineFactoryD3D12::LoadD3D12.
        void* EnumerateAdapters(IEngineFactoryD3D12*,
                                               DIRECT3D_FEATURE_LEVEL MinFeatureLevel,
                                               uint*                 NumAdapters,
                                               GraphicsAdapterInfo*   Adapters); 

        /// Enumerates available display modes for the specified output of the specified adapter.

        /// \param [in] MinFeatureLevel - Minimum feature level of the adapter that was given to EnumerateAdapters().
        /// \param [in] AdapterId       - Id of the adapter enumerated by EnumerateAdapters().
        /// \param [in] OutputId        - Adapter output id.
        /// \param [in] Format          - Display mode format.
        /// \param [in, out] NumDisplayModes - Number of display modes. If DisplayModes is null, this
        ///                                    value is overwritten with the number of display modes
        ///                                    available for this output. If DisplayModes is not null,
        ///                                    this value should contain the maximum number of elements
        ///                                    to be written to DisplayModes array. It is overwritten with
        ///                                    the actual number of display modes written.
        ///
        /// \note           D3D12 must be loaded before this method can be called, see IEngineFactoryD3D12::LoadD3D12.
        void* EnumerateDisplayModes(IEngineFactoryD3D12*,
                                                   Version                MinFeatureLevel,
                                                   uint                   AdapterId,
                                                   uint                   OutputId,
                                                   TEXTURE_FORMAT         Format,
                                                   uint*                  NumDisplayModes,
                                                   DisplayModeAttribs*    DisplayModes);
    }
}

struct IEngineFactoryD3D12Vtbl { IEngineFactoryD3D12Methods EngineFactoryD3D12; }
struct IEngineFactoryD3D12 { IEngineFactoryD3D12Vtbl* pVtbl; }

//#    define IEngineFactoryD3D12_LoadD3D12(This, ...)                    CALL_IFACE_METHOD(EngineFactoryD3D12, LoadD3D12,                    This, __VA_ARGS__)
//#    define IEngineFactoryD3D12_CreateDeviceAndContextsD3D12(This, ...) CALL_IFACE_METHOD(EngineFactoryD3D12, CreateDeviceAndContextsD3D12, This, __VA_ARGS__)
//#    define IEngineFactoryD3D12_CreateSwapChainD3D12(This, ...)         CALL_IFACE_METHOD(EngineFactoryD3D12, CreateSwapChainD3D12,         This, __VA_ARGS__)
//#    define IEngineFactoryD3D12_AttachToD3D12Device(This, ...)          CALL_IFACE_METHOD(EngineFactoryD3D12, AttachToD3D12Device,          This, __VA_ARGS__)
//#    define IEngineFactoryD3D12_EnumerateAdapters(This, ...)            CALL_IFACE_METHOD(EngineFactoryD3D12, EnumerateAdapters,            This, __VA_ARGS__)
//#    define IEngineFactoryD3D12_EnumerateDisplayModes(This, ...)        CALL_IFACE_METHOD(EngineFactoryD3D12, EnumerateDisplayModes,        This, __VA_ARGS__)

bool* IEngineFactoryD3D12_LoadD3D12(IEngineFactoryD3D12* factory, const(char)* DllName = "d3d12.dll") {
    return factory.pVtbl.EngineFactoryD3D12.LoadD3D12(factory, DllName);
}

void* IEngineFactoryD3D12_CreateDeviceAndContextsD3D12(IEngineFactoryD3D12* factory,
                                                      const(EngineD3D12CreateInfo)* EngineCI,
                                                      IRenderDevice**                 ppDevice,
                                                      IDeviceContext**                ppContexts) {
    return factory.pVtbl.EngineFactoryD3D12.CreateDeviceAndContextsD3D12(factory, EngineCI, ppDevice, ppContexts);
}

void* IEngineFactoryD3D12_CreateSwapChainD3D12(IEngineFactoryD3D12* factory,
                                                     void*                   pd3d12NativeDevice,
                                                     void*                   pd3d12NativeCommandQueue,
                                                     IMemoryAllocator*       pRawMemAllocator,
                                                     ICommandQueueD3D12**    ppCommandQueue) {
    return factory.pVtbl.EngineFactoryD3D12.CreateSwapChainD3D12(factory, pd3d12NativeDevice, pd3d12NativeCommandQueue, pRawMemAllocator, ppCommandQueue);
}

void* IEngineFactoryD3D12_AttachToD3D12Device(IEngineFactoryD3D12* factory,
                                             void*                           pd3d12NativeDevice,
                                             Uint32                          CommandQueueCount,
                                             ICommandQueueD3D12**            ppCommandQueues,
                                             const(EngineD3D12CreateInfo)*   EngineCI,
                                             IRenderDevice**                 ppDevice,
                                             IDeviceContext**                ppContexts) {
    return factory.pVtbl.EngineFactoryD3D12.AttachToD3D12Device(factory, pd3d12NativeDevice, CommandQueueCount, ppCommandQueues, EngineCI, ppDevice, ppContexts);
}

void* IEngineFactoryD3D12_EnumerateAdapters(IEngineFactoryD3D12* factory,
                                           DIRECT3D_FEATURE_LEVEL MinFeatureLevel,
                                           uint*                 NumAdapters,
                                           GraphicsAdapterInfo*   Adapters) {
    return factory.pVtbl.EngineFactoryD3D12.EnumerateAdapters(factory, MinFeatureLevel, NumAdapters, Adapters);
}

void* IEngineFactoryD3D12_EnumerateDisplayModes(IEngineFactoryD3D12* factory,
                                               Version                MinFeatureLevel,
                                               uint                   AdapterId,
                                               uint                   OutputId,
                                               TEXTURE_FORMAT         Format,
                                               uint*                  NumDisplayModes,
                                               DisplayModeAttribs*    DisplayModes) {
    return factory.pVtbl.EngineFactoryD3D12.EnumerateDisplayModes(factory, MinFeatureLevel, AdapterId, OutputId, Format, NumDisplayModes, DisplayModes);
}

version(BindDiligent_Dynamic) {
    IEngineFactoryD3D12* function() GetEngineFactoryD3D12Type;

    GetEngineFactoryD3D12Type Diligent_LoadGraphicsEngineD3D12()
    {
        return cast(GetEngineFactoryD3D12Type)LoadEngineDll("GraphicsEngineD3D12", "GetEngineFactoryD3D12");
    }
}
else { IEngineFactoryD3D12* Diligent_GetEngineFactoryD3D12(); }
