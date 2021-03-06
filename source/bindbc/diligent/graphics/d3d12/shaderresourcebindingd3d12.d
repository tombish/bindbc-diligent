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

module bindbc.diligent.graphics.d3d12.shaderresourcebindingd3d12;

/// \file
/// Definition of the Diligent::IShaderResourceBindingD3D12 interface and related data structures

import bindbc.diligent.graphics.shaderresourcebinding;

// {70DD5C7C-81FA-4D9A-942F-D1B91423FAAC}
static const INTERFACE_ID IID_ShaderResourceBindingD3D12 =
    INTERFACE_ID(0x70dd5c7c, 0x81fa, 0x4d9a, [0x94, 0x2f, 0xd1, 0xb9, 0x14, 0x23, 0xfa, 0xac]);

struct IShaderResourceBindingD3D12Vtbl {}

struct IShaderResourceBindingD3D12
{
    IShaderResourceBindingD3D12Vtbl* pVtbl;
}