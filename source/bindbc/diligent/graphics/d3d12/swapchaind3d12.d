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

module bindbc.diligent.graphics.d3d12.swapchaind3d12;

/// \file
/// Definition of the Diligent::ISwapChainD3D12 interface

//import directx.dxgi1_4;

import bindbc.diligent.graphics.swapchain;
import bindbc.diligent.graphics.d3d12.textured3d12;

// {C9F8384D-A45E-4970-8447-394177E5B0EE}
static const INTERFACE_ID IID_SwapChainD3D12 =
    INTERFACE_ID(0xc9f8384d, 0xa45e, 0x4970, [0x84, 0x47, 0x39, 0x41, 0x77, 0xe5, 0xb0, 0xee]);

/// Exposes Direct3D12-specific functionality of a swap chain.
struct ISwapChainD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns a pointer to the IDXGISwapChain interface of the internal DXGI object.

        /// The method does *NOT* increment the reference counter of the returned object,
        /// so Release() must not be called.
        IDXGISwapChain** GetDXGISwapChain(ISwapChainD3D12*);
    }
}

struct ISwapChainD3D12Vtbl { ISwapChainD3D12Methods SwapChainD3D12; }
struct ISwapChainD3D12 { ISwapChainD3D12Vtbl* pVtbl; }

IDXGISwapChain** ISwapChainD3D12_GetDXGISwapChain(ISwapChainD3D12* swapchain) {
    return swapchain.pVtbl.SwapChainD3D12.GetDXGISwapChain(swapchain);
}