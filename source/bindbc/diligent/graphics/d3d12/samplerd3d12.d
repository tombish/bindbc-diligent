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

module bindbc.diligent.graphics.d3d12.samplerd3d12;

/// \file
/// Definition of the Diligent::ISamplerD3D12 interface

import bindbc.diligent.graphics.sampler;

// {31A3BFAF-738E-4D8C-AD18-B021C5D948DD}
static const INTERFACE_ID IID_SamplerD3D12 =
    INTERFACE_ID(0x31a3bfaf, 0x738e, 0x4d8c, [0xad, 0x18, 0xb0, 0x21, 0xc5, 0xd9, 0x48, 0xdd]);

/// Exposes Direct3D12-specific functionality of a sampler object.
struct ISamplerD3D12Methods
{
    extern(C) @nogc nothrow {
        /// Returns a CPU descriptor handle of the D3D12 sampler object

        /// The method does *NOT* increment the reference counter of the returned object,
        /// so Release() must not be called.
        D3D12_CPU_DESCRIPTOR_HANDLE* GetCPUDescriptorHandle(ISamplerD3D12*);
    }
}

struct ISamplerD3D12Vtbl { ISamplerD3D12Methods SamplerD3D12; }
struct ISamplerD3D12 { ISamplerD3D12Vtbl* pVtbl; }

D3D12_CPU_DESCRIPTOR_HANDLE* ISamplerD3D12_GetCPUDescriptorHandle(ISamplerD3D12* sampler) {
    return sampler.pVtbl.SamplerD3D12.GetCPUDescriptorHandle(sampler);
}