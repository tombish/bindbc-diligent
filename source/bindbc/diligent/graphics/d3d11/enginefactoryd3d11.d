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

module bindbc.diligent.graphics.d3d11.enginefactoryd3d11;

/// \file
/// Declaration of functions that initialize Direct3D11-based engine implementation

import bindbc.diligent.graphics.enginefactory;
import bindbc.diligent.graphics.renderdevice;
import bindbc.diligent.graphics.devicecontext;
import bindbc.diligent.graphics.swapchain;

version(BindDiligent_Dynamic) { import bindbc.diligent.graphics.loadenginedll; }

// {62663A30-AAF0-4A9A-9729-9EAC6BF789F2}
static const INTERFACE_ID IID_EngineFactoryD3D11 =
    INTERFACE_ID(0x62663a30, 0xaaf0, 0x4a9a, [0x97, 0x29, 0x9e, 0xac, 0x6b, 0xf7, 0x89, 0xf2]);

/// Engine factory for Direct3D11 rendering backend.
struct IEngineFactoryD3D11Methods
{
    /// Creates a render device and device contexts for Direct3D11-based engine implementation.

    /// \param [in] EngineCI  - Engine creation info.
    /// \param [out] ppDevice - Address of the memory location where pointer to
    ///                         the created device will be written.
    /// \param [out] ppContexts - Address of the memory location where pointers to
    ///                           the contexts will be written. Immediate context goes at
    ///                           position 0. If EngineCI.NumDeferredContexts > 0,
    ///                           pointers to deferred contexts are written afterwards.
    void* CreateDeviceAndContextsD3D11(IEngineFactoryD3D11*, const EngineD3D11CreateInfo* EngineCI,
                                                      IRenderDevice**                    ppDevice,
                                                      IDeviceContext**                   ppContexts);

    /// Creates a swap chain for Direct3D11-based engine implementation.

    /// \param [in] pDevice           - Pointer to the render device.
    /// \param [in] pImmediateContext - Pointer to the immediate device context.
    /// \param [in] SCDesc            - Swap chain description.
    /// \param [in] FSDesc            - Fullscreen mode description.
    /// \param [in] Window            - Platform-specific native window description that
    ///                                 the swap chain will be associated with:
    ///                                 * On Win32 platform, this is the window handle (HWND)
    ///                                 * On Universal Windows Platform, this is the reference
    ///                                   to the core window (Windows::UI::Core::CoreWindow)
    ///
    /// \param [out] ppSwapChain    - Address of the memory location where pointer to the new
    ///                               swap chain will be written.
    void* CreateSwapChainD3D11(IEngineFactoryD3D11*,
                                IRenderDevice*            pDevice,
                                IDeviceContext*           pImmediateContext,
                                const SwapChainDesc*      SCDesc,
                                const FullScreenModeDesc* FSDesc,
                                const NativeWindow*       Window,
                                ISwapChain**              ppSwapChain);

    /// Attaches to existing Direct3D11 render device and immediate context.

    /// \param [in] pd3d11NativeDevice     - pointer to the native Direct3D11 device.
    /// \param [in] pd3d11ImmediateContext - pointer to the native Direct3D11 immediate context.
    /// \param [in] EngineCI               - Engine creation info.
    /// \param [out] ppDevice              - Address of the memory location where pointer to
    ///                                      the created device will be written.
    /// \param [out] ppContexts - Address of the memory location where pointers to
    ///                           the contexts will be written. Immediate context goes at
    ///                           position 0. If EngineCI.NumDeferredContexts > 0,
    ///                           pointers to the deferred contexts are written afterwards.
    void* AttachToD3D11Device(IEngineFactoryD3D11*,
                                void*                        pd3d11NativeDevice,
                                void*                        pd3d11ImmediateContext,
                                const EngineD3D11CreateInfo* EngineCI,
                                IRenderDevice**              ppDevice,
                                IDeviceContext**             ppContexts);

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
    void* EnumerateDisplayModes(IEngineFactoryD3D11*,
                                               Version              MinFeatureLevel,
                                               uint                 AdapterId,
                                               uint                 OutputId,
                                               TEXTURE_FORMAT       Format,
                                               uint*                NumDisplayModes,
                                               DisplayModeAttribs*  DisplayModes);
}

struct IEngineFactoryD3D11Vtbl { IEngineFactoryD3D11Methods EngineFactoryD3D11; }
struct IEngineFactoryD3D11 { IEngineFactoryD3D11Vtbl* pVtbl; }

// #    define IEngineFactoryD3D11_CreateDeviceAndContextsD3D11(This, ...) CALL_IFACE_METHOD(EngineFactoryD3D11, CreateDeviceAndContextsD3D11, This, __VA_ARGS__)
// #    define IEngineFactoryD3D11_CreateSwapChainD3D11(This, ...)         CALL_IFACE_METHOD(EngineFactoryD3D11, CreateSwapChainD3D11,         This, __VA_ARGS__)
// #    define IEngineFactoryD3D11_AttachToD3D11Device(This, ...)          CALL_IFACE_METHOD(EngineFactoryD3D11, AttachToD3D11Device,          This, __VA_ARGS__)
// #    define IEngineFactoryD3D11_EnumerateDisplayModes(This, ...)        CALL_IFACE_METHOD(EngineFactoryD3D11, EnumerateDisplayModes,        This, __VA_ARGS__)

void* IEngineFactoryD3D11_CreateDeviceAndContextsD3D11(IEngineFactoryD3D11* factory,
                                                        const EngineD3D11CreateInfo* EngineCI,
                                                        IRenderDevice**                    ppDevice,
                                                        IDeviceContext**                   ppContexts) {
    return factory.pVtbl.EngineFactoryD3D11.CreateDeviceAndContextsD3D11(factory, EngineCI, ppDevice, ppContexts);
}

void* IEngineFactoryD3D11_CreateSwapChainD3D11(IEngineFactoryD3D11* factory,
                                                IRenderDevice*            pDevice,
                                                IDeviceContext*           pImmediateContext,
                                                const SwapChainDesc*      SCDesc,
                                                const FullScreenModeDesc* FSDesc,
                                                const NativeWindow*       Window,
                                                ISwapChain**              ppSwapChain) {
    return factory.pVtbl.EngineFactoryD3D11.CreateSwapChainD3D11(factory, pDevice, pImmediateContext, SCDesc, FSDesc, Window, ppSwapChain);
}

void* IEngineFactoryD3D11_AttachToD3D11Device(IEngineFactoryD3D11* factory,
                                void*                        pd3d11NativeDevice,
                                void*                        pd3d11ImmediateContext,
                                const EngineD3D11CreateInfo* EngineCI,
                                IRenderDevice**              ppDevice,
                                IDeviceContext**             ppContexts) {
    return factory.pVtbl.EngineFactoryD3D11.AttachToD3D11Device(factory, pd3d11NativeDevice, pd3d11ImmediateContext, EngineCI, ppDevice, ppContexts);
}

void* IEngineFactoryD3D11_EnumerateDisplayModes(IEngineFactoryD3D11* factory,
                                               Version              MinFeatureLevel,
                                               uint                 AdapterId,
                                               uint                 OutputId,
                                               TEXTURE_FORMAT       Format,
                                               uint*                NumDisplayModes,
                                               DisplayModeAttribs*  DisplayModes) {
    return factory.pVtbl.EngineFactoryD3D11.EnumerateDisplayModes(factory, MinFeatureLevel, AdapterId, OutputId, Format, NumDisplayModes, DisplayModes);
}

version(BindDiligent_Dynamic) {
    IEngineFactoryD3D11* function() GetEngineFactoryD3D11Type;

    GetEngineFactoryD3D11Type Diligent_LoadGraphicsEngineD3D11()
    {
        return cast(GetEngineFactoryD3D11Type)LoadEngineDll("GraphicsEngineD3D11", "GetEngineFactoryD3D11");
    }
}
else { IEngineFactoryD3D11* Diligent_GetEngineFactoryD3D11(); }
