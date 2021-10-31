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

module bindbc.diligent.graphics.d3d12.renderdeviced3d12;

/// \file
/// Definition of the Diligent::IRenderDeviceD3D12 interface

import bindbc.diligent.graphics.renderdevice;

// {C7987C98-87FE-4309-AE88-E98F044B00F6}
static const INTERFACE_ID IID_RenderDeviceD3D12 =
    INTERFACE_ID(0xc7987c98, 0x87fe, 0x4309, [0xae, 0x88, 0xe9, 0x8f, 0x4, 0x4b, 0x0, 0xf6]);

/// Exposes Direct3D12-specific functionality of a render device.
struct IEngineFactoryD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns ID3D12Device interface of the internal Direct3D12 device object.

        /// The method does *NOT* increment the reference counter of the returned object,
        /// so Release() must not be called.
        ID3D12Device** GetD3D12Device(IRenderDeviceD3D12*);

        /// Creates a texture object from native d3d12 resource

        /// \param [in]  pd3d12Texture - pointer to the native D3D12 texture
        /// \param [in]  InitialState  - Initial texture state. See Diligent::RESOURCE_STATE.
        /// \param [out] ppTexture     - Address of the memory location where the pointer to the
        ///                              texture interface will be stored.
        ///                              The function calls AddRef(), so that the new object will contain
        ///                              one reference.
        void* CreateTextureFromD3DResource(IRenderDeviceD3D12*,
                                            ID3D12Resource* pd3d12Texture,
                                            RESOURCE_STATE  InitialState,
                                            ITexture**      ppTexture);

        /// Creates a buffer object from native d3d12 resource

        /// \param [in]  pd3d12Buffer - Pointer to the native d3d12 buffer resource
        /// \param [in]  BuffDesc     - Buffer description. The system can recover buffer size, but
        ///                             the rest of the fields need to be populated by the client
        ///                             as they cannot be recovered from d3d12 resource description
        /// \param [in]  InitialState - Initial buffer state. See Diligent::RESOURCE_STATE.
        /// \param [out] ppBuffer     - Address of the memory location where the pointer to the
        ///                             buffer interface will be stored.
        ///                             The function calls AddRef(), so that the new object will contain
        ///                             one reference.
        void* CreateBufferFromD3DResource(IRenderDeviceD3D12*,
                                            ID3D12Resource*     pd3d12Buffer,
                                            const(BufferDesc)*   BuffDesc,
                                            RESOURCE_STATE      InitialState,
                                            IBuffer**           ppBuffer);
        
        /// Creates a bottom-level AS object from native d3d12 resource

        /// \param [in]  pd3d12BLAS   - Pointer to the native d3d12 acceleration structure resource
        /// \param [in]  Desc         - Bottom-level AS description.
        /// \param [in]  InitialState - Initial BLAS state. Can be RESOURCE_STATE_UNKNOWN, RESOURCE_STATE_BUILD_AS_READ, RESOURCE_STATE_BUILD_AS_WRITE.
        ///                             See Diligent::RESOURCE_STATE.
        /// \param [out] ppBLAS       - Address of the memory location where the pointer to the
        ///                             bottom-level AS interface will be stored.
        ///                             The function calls AddRef(), so that the new object will contain
        ///                             one reference.
        void* CreateBLASFromD3DResource(IRenderDeviceD3D12*,
                                        ID3D12Resource*             pd3d12BLAS,
                                        const(BottomLevelASDesc)*    Desc,
                                        RESOURCE_STATE              InitialState,
                                        IBottomLevelAS**            ppBLAS);

        /// Creates a top-level AS object from native d3d12 resource

        /// \param [in]  pd3d12TLAS   - Pointer to the native d3d12 acceleration structure resource
        /// \param [in]  Desc         - Top-level AS description.
        /// \param [in]  InitialState - Initial TLAS state. Can be RESOURCE_STATE_UNKNOWN, RESOURCE_STATE_BUILD_AS_READ, RESOURCE_STATE_BUILD_AS_WRITE, RESOURCE_STATE_RAY_TRACING.
        ///                             See Diligent::RESOURCE_STATE.
        /// \param [out] ppTLAS       - Address of the memory location where the pointer to the
        ///                             top-level AS interface will be stored.
        ///                             The function calls AddRef(), so that the new object will contain
        ///                             one reference.
        void* CreateTLASFromD3DResource(IRenderDeviceD3D12*,
                                           ID3D12Resource*          pd3d12TLAS,
                                           const(TopLevelASDesc)*    Desc,
                                           RESOURCE_STATE           InitialState,
                                           ITopLevelAS**            ppTLAS);
    }
}

struct IRenderDeviceD3D12Vtbl { IRenderDeviceD3D12Methods RenderDeviceD3D12; }
struct IRenderDeviceD3D12 { IRenderDeviceD3D12Vtbl* pVtbl; }

ID3D12Device** IRenderDeviceD3D12_GetD3D12Device(IRenderDeviceD3D12* renderDevice) {
    return renderDevice.pVtbl.RenderDeviceD3D12.GetD3D12Device(renderDevice);
}

void* IRenderDeviceD3D12_CreateTextureFromD3DResource(IRenderDeviceD3D12*   renderDevice,
                                                        ID3D12Resource*     pd3d12Texture,
                                                        RESOURCE_STATE      InitialState,
                                                        ITexture**          ppTexture) {
    return renderDevice.pVtbl.RenderDeviceD3D12.CreateTLASFromD3DResource(renderDevice, pd3d12Texture, InitialState, ppTexture);
}

void* IRenderDeviceD3D12_CreateBufferFromD3DResource(IRenderDeviceD3D12*    renderDevice,
                                                    ID3D12Resource*         pd3d12Buffer,
                                                    const(BufferDesc)*      BuffDesc,
                                                    RESOURCE_STATE          InitialState,
                                                    IBuffer**               ppBuffer) {
    return renderDevice.pVtbl.RenderDeviceD3D12.CreateBufferFromD3DResource(renderDevice, pd3d12Buffer, BuffDesc,InitialState, ppBuffer); 
}

void* IRenderDeviceD3D12_CreateBLASFromD3DResource(IRenderDeviceD3D12*          renderDevice,
                                                    ID3D12Resource*             pd3d12BLAS,
                                                    const(BottomLevelASDesc)*   Desc,
                                                    RESOURCE_STATE              InitialState,
                                                    IBottomLevelAS**            ppBLAS) {
    return renderDevice.pVtbl.RenderDeviceD3D12.CreateBLASFromD3DResource(renderDevice, pd3d12BLAS, Desc,InitialState, ppBLAS); 
}

void* IRenderDeviceD3D12_CreateTLASFromD3DResource(IRenderDeviceD3D12*      renderDevice,
                                                   ID3D12Resource*          pd3d12TLAS,
                                                   const(TopLevelASDesc)*   Desc,
                                                   RESOURCE_STATE           InitialState,
                                                   ITopLevelAS**            ppTLAS) {
    return renderDevice.pVtbl.RenderDeviceD3D12.CreateTLASFromD3DResource(renderDevice, pd3d12TLAS, Desc,InitialState, ppTLAS); 
}