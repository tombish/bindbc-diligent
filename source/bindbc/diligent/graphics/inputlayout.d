/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/InputLayout.h
 *  The original licence follows this statement
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

module bindbc.diligent.graphics.inputlayout;

/// \file
/// Definition input layout

import bindbc.diligent.graphics.graphicstypes;

enum int MAX_LAYOUT_ELEMENTS        = 16;
enum int LAYOUT_ELEMENT_AUTO_OFFSET = 0xFFFFFFFF;
enum int LAYOUT_ELEMENT_AUTO_STRIDE = 0xFFFFFFFF;

/// Input frequency
enum INPUT_ELEMENT_FREQUENCY
{
    /// Frequency is undefined.
    INPUT_ELEMENT_FREQUENCY_UNDEFINED = 0,

    /// Input data is per-vertex data.
    INPUT_ELEMENT_FREQUENCY_PER_VERTEX,

    /// Input data is per-instance data.
    INPUT_ELEMENT_FREQUENCY_PER_INSTANCE,

    /// Helper value that stores the total number of frequencies in the enumeration.
    INPUT_ELEMENT_FREQUENCY_NUM_FREQUENCIES
}

/// Description of a single element of the input layout
struct LayoutElement
{
    /// HLSL semantic. Default value ("ATTRIB") allows HLSL shaders to be converted
    /// to GLSL and used in OpenGL backend as well as compiled to SPIRV and used
    /// in Vulkan backend.
    /// Any value other than default will only work in Direct3D11 and Direct3D12 backends.
    const(char)* HLSLSemantic = "ATTRIB";

    /// Input index of the element that is specified in the vertex shader.
    /// In Direct3D11 and Direct3D12 backends this is the semantic index.
    int InputIndex = 0;

    /// Buffer slot index that this element is read from.
    int BufferSlot = 0;

    /// Number of components in the element. Allowed values are 1, 2, 3, and 4.
    int NumComponents = 0;

    /// Type of the element components, see Diligent::VALUE_TYPE for details.
    VALUE_TYPE ValueType = VALUE_TYPE.VT_FLOAT32;

    /// For signed and unsigned integer value types 
    /// (VT_INT8, VT_INT16, VT_INT32, VT_UINT8, VT_UINT16, VT_UINT32)
    /// indicates if the value should be normalized to [-1,+1] or 
    /// [0, 1] range respectively. For floating point types
    /// (VT_FLOAT16 and VT_FLOAT32), this member is ignored.
    bool IsNormalized = true;

    /// Relative offset, in bytes, to the element bits.
    /// If this value is set to LAYOUT_ELEMENT_AUTO_OFFSET (default value), the offset will
    /// be computed automatically by placing the element right after the previous one.
    int RelativeOffset = LAYOUT_ELEMENT_AUTO_OFFSET;

    /// Stride, in bytes, between two elements, for this buffer slot.
    /// If this value is set to LAYOUT_ELEMENT_AUTO_STRIDE, the stride will be
    /// computed automatically assuming that all elements in the same buffer slot are
    /// packed one after another. If the buffer slot contains multiple layout elements,
    /// they all must specify the same stride or use LAYOUT_ELEMENT_AUTO_STRIDE value.
    int Stride = LAYOUT_ELEMENT_AUTO_STRIDE;

    INPUT_ELEMENT_FREQUENCY Frequency = INPUT_ELEMENT_FREQUENCY.INPUT_ELEMENT_FREQUENCY_PER_VERTEX;
    
    /// The number of instances to draw using the same per-instance data before advancing 
    /// in the buffer by one element.
    int InstanceDataStepRate = 1;
}

/// Layout description

/// This structure is used by IRenderDevice::CreateGraphicsPipelineState().
struct InputLayoutDesc
{
    /// Array of layout elements
    const LayoutElement* LayoutElements = null;
    /// Number of layout elements
    int NumElements = 0;
}
