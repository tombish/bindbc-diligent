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

module bindbc.diligent.graphics.d3d11.renderdeviced3d11;

/// \file
/// Definition of the Diligent::IRenderDeviceD3D11 interface

import bindbc.diligent.graphics.renderdevice;

// {05B1CBB8-FCAD-49EE-BADA-7801223EC3FE}
static const INTERFACE_ID IID_RenderDeviceD3D11 =
    INTERFACE_ID(0x5b1cbb8, 0xfcad, 0x49ee, [0xba, 0xda, 0x78, 0x1, 0x22, 0x3e, 0xc3, 0xfe]);

/// Exposes Direct3D11-specific functionality of a render device.
struct IRenderDeviceD3D11Methods
{
    /// Returns a pointer to the ID3D11Device interface of the internal Direct3D11 object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    ID3D11Device** GetD3D11Device(IRenderDeviceD3D11*);

    /// Creates a buffer object from native d3d11 buffer

    /// \param [in]  pd3d11Buffer - Pointer to the native buffer
    /// \param [in]  BuffDesc     - Buffer description. Most of the fields will be
    ///                             populated automatically if left in default values.
    ///                             The only field that must be populated is BufferDesc::Format,
    ///                             when initializing a formatted buffer.
    /// \param [in]  InitialState - Initial buffer state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppBuffer     - Address of the memory location where the pointer to the
    ///                             buffer interface will be stored.
    ///                             The function calls AddRef(), so that the new object will contain
    ///                             one reference.
    void* CreateBufferFromD3DResource(IRenderDeviceD3D11*,
                                                     ID3D11Buffer*        pd3d11Buffer,
                                                     const BufferDesc* BuffDesc,
                                                     RESOURCE_STATE       InitialState,
                                                     IBuffer**            ppBuffer);

    /// Creates a texture object from native d3d11 1D texture

    /// \param [in]  pd3d11Texture - pointer to the native 1D texture
    /// \param [in]  InitialState  - Initial texture state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppTexture     - Address of the memory location where the pointer to the
    ///                              texture interface will be stored.
    ///                              The function calls AddRef(), so that the new object will contain
    ///                              one reference.
    void* CreateTexture1DFromD3DResource(IRenderDeviceD3D11*,
                                                        ID3D11Texture1D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture);

    /// Creates a texture object from native d3d11 2D texture

    /// \param [in]  pd3d11Texture - pointer to the native 2D texture
    /// \param [in]  InitialState  - Initial texture state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppTexture     - Address of the memory location where the pointer to the
    ///                              texture interface will be stored.
    ///                              The function calls AddRef(), so that the new object will contain
    ///                              one reference.
    void* CreateTexture2DFromD3DResource(IRenderDeviceD3D11*,
                                                        ID3D11Texture2D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture);

    /// Creates a texture object from native d3d11 3D texture

    /// \param [in]  pd3d11Texture - pointer to the native 3D texture
    /// \param [in]  InitialState  - Initial texture state. See Diligent::RESOURCE_STATE.
    /// \param [out] ppTexture     - Address of the memory location where the pointer to the
    ///                              texture interface will be stored.
    ///                              The function calls AddRef(), so that the new object will contain
    ///                              one reference.
    void* CreateTexture3DFromD3DResource(IRenderDeviceD3D11*,
                                                        ID3D11Texture3D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture);
}

struct IRenderDeviceD3D11Vtbl { IRenderDeviceD3D11Methods RenderDeviceD3D11; }
struct IRenderDeviceD3D11 { IRenderDeviceD3D11Vtbl* pVtbl; }

ID3D11Device** IRenderDeviceD3D11_GetD3D11Device(IRenderDeviceD3D11* device) {
    return device.pVtbl.RenderDeviceD3D11.GetD3D11Device(device);
}

void* IRenderDeviceD3D11_CreateBufferFromD3DResource(IRenderDeviceD3D11*    device,
                                                     ID3D11Buffer*          pd3d11Buffer,
                                                     const BufferDesc*      BuffDesc,
                                                     RESOURCE_STATE         InitialState,
                                                     IBuffer**              ppBuffer){
    return device.pVtbl.RenderDeviceD3D11.CreateBufferFromD3DResource(device, pd3d11Buffer, BuffDesc, InitialState, ppBuffer); 
}

void* IRenderDeviceD3D11_CreateTexture1DFromD3DResource(IRenderDeviceD3D11* device,
                                                        ID3D11Texture1D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture) {
    return device.pVtbl.RenderDeviceD3D11.CreateTexture1DFromD3DResource(device, pd3d11Texture, InitialState, ppTexture);
}

void* IRenderDeviceD3D11_CreateTexture2DFromD3DResource(IRenderDeviceD3D11* device,
                                                        ID3D11Texture2D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture) {
    return device.pVtbl.RenderDeviceD3D11.CreateTexture2DFromD3DResource(device, pd3d11Texture, InitialState, ppTexture);
}

void* IRenderDeviceD3D11_CreateTexture3DFromD3DResource(IRenderDeviceD3D11* device,
                                                        ID3D11Texture3D* pd3d11Texture,
                                                        RESOURCE_STATE   InitialState,
                                                        ITexture**       ppTexture){
    return device.pVtbl.RenderDeviceD3D11.CreateTexture3DFromD3DResource(device, pd3d11Texture, InitialState, ppTexture);
}