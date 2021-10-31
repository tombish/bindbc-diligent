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

module bindbc.diligent.graphics.d3d12.bottomlevelasd3d12;

/// \file
/// Definition of the Diligent::IBottomLevelASD3D12 interface

import bindbc.diligent.graphics.bottomlevelas;
import bindbc.diligent.graphics.devicecontext;

// {610228AF-F161-4B12-A00E-71E6E3BB97FE}
static const INTERFACE_ID IID_BottomLevelASD3D12 =
    INTERFACE_ID(0x610228af, 0xf161, 0x4b12, [0xa0, 0xe, 0x71, 0xe6, 0xe3, 0xbb, 0x97, 0xfe]);

/// Exposes Direct3D12-specific functionality of a bottom-level acceleration structure object.
struct IBottomLevelASD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns ID3D12Resource interface of the internal D3D12 acceleration structure object.

        /// The method does *NOT* increment the reference counter of the returned object,
        /// so Release() must not be called.
        ID3D12Resource** GetD3D12BLAS(IBottomLevelASD3D12*);
    }
}

struct IBottomLevelASD3D12Vtbl { IBottomLevelASD3D12Methods BottomLevelASD3D12; }
struct IBottomLevelASD3D12 { IBottomLevelASD3D12Vtbl* pVtbl; }

ID3D12Resource** IBottomLevelASD3D12_GetD3D12BLAS(IBottomLevelASD3D12* bottomLevelAS) {
    return bottomLevelAS.pVtbl.BottomLevelASD3D12.GetD3D12BLAS(bottomLevelAS);
}