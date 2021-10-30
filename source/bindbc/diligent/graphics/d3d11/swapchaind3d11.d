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

module bindbc.diligent.graphics.d3d11.swapchaind3d11;

/// \file
/// Definition of the Diligent::ISwapChainD3D11 interface

import bindbc.diligent.graphics.swapchain;
import bindbc.diligent.graphics.d3d11.textureviewd3d11;

// {4DAF2E76-9204-4DC4-A53A-B00097412D3A}
static const INTERFACE_ID IID_SwapChainD3D11 =
    INTERFACE_ID(0x4daf2e76, 0x9204, 0x4dc4, [0xa5, 0x3a, 0xb0, 0x0, 0x97, 0x41, 0x2d, 0x3a]);

/// Exposes Direct3D11-specific functionality of a swap chain.
struct ISwapChainD3D11Methods
{
    /// Returns render target view of the back buffer in the swap chain
    ITextureViewD3D11** GetCurrentBackBufferRTV(ISwapChainD3D11*);

    /// Returns depth-stencil view of the depth buffer
    ITextureViewD3D11** GetDepthBufferDSV(ISwapChainD3D11*);

    /// Returns a pointer to the IDXGISwapChain interface of the internal DXGI object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    IDXGISwapChain** GetDXGISwapChain(ISwapChainD3D11*);
}

struct ISwapChainD3D11Vtbl { ISwapChainD3D11Methods SwapChainD3D11; }
struct ISwapChainD3D11 { ISwapChainD3D11Vtbl* pVtbl; }

ITextureViewD3D11** ISwapChainD3D11_GetCurrentBackBufferRTV(ISwapChainD3D11* swapchain) {
    return swapchain.pVtbl.SwapChainD3D11.GetCurrentBackBufferRTV(swapchain);
}

ITextureViewD3D11** ISwapChainD3D11_GetDepthBufferDSV(ISwapChainD3D11* swapchain) {
    return swapchain.pVtbl.SwapChainD3D11.GetDepthBufferDSV(swapchain);
}

IDXGISwapChain** ISwapChainD3D11_GetDXGISwapChain(ISwapChainD3D11* swapchain) {
    return swapchain.pVtbl.SwapChainD3D11.GetDXGISwapChain(swapchain);
}