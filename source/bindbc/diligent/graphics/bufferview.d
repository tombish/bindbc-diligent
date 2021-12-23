/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 *  Modified source based on DiligentCore/Graphics/GraphicsEngine/interface/BufferView.h
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
 
module bindbc.diligent.graphics.bufferview;

public import bindbc.diligent.graphics.deviceobject;
public import bindbc.diligent.graphics.buffer;

// {E2E83490-E9D2-495B-9A83-ABB413A38B07}
static const INTERFACE_ID IID_BufferView = 
    INTERFACE_ID(0xe2e83490, 0xe9d2, 0x495b, [0x9a, 0x83, 0xab, 0xb4, 0x13, 0xa3, 0x8b, 0x7]);

/// Buffer format description
struct BufferFormat
{
    /// Type of components. For a formatted buffer views, this value cannot be VT_UNDEFINED
    VALUE_TYPE ValueType = VALUE_TYPE.VT_UNDEFINED;

    /// Number of components. Allowed values: 1, 2, 3, 4. 
    /// For a formatted buffer, this value cannot be 0
    ubyte NumComponents = 0;

    /// For signed and unsigned integer value types 
    /// (VT_INT8, VT_INT16, VT_INT32, VT_UINT8, VT_UINT16, VT_UINT32)
    /// indicates if the value should be normalized to [-1,+1] or 
    /// [0, 1] range respectively. For floating point types
    /// (VT_FLOAT16 and VT_FLOAT32), this member is ignored.
    bool IsNormalized = false;
}

/// Buffer view description
struct BufferViewDesc
{
    DeviceObjectAttribs _DeviceObjectAttribs;

    /// View type. See Diligent::BUFFER_VIEW_TYPE for details.
    BUFFER_VIEW_TYPE ViewType = BUFFER_VIEW_TYPE.BUFFER_VIEW_UNDEFINED;

    /// Format of the view. This member is only used for formatted and raw buffers.
    /// To create raw view of a raw buffer, set Format.ValueType member to VT_UNDEFINED
    /// (default value).
    BufferFormat Format;

    /// Offset in bytes from the beginning of the buffer to the start of the
    /// buffer region referenced by the view
    uint ByteOffset = 0;

    /// Size in bytes of the referenced buffer region
    uint ByteWidth = 0;
}

/// Buffer view interface

/// To create a buffer view, call IBuffer::CreateView().
/// \remarks
/// Buffer view holds strong references to the buffer. The buffer
/// will not be destroyed until all views are released.
struct IBufferViewMethods
{
    /// Returns pointer to the referenced buffer object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    IBuffer** GetBuffer(IBufferView*);
}

struct IBufferViewVtbl { IBufferViewMethods BufferView; }
struct IBufferView { IBufferViewVtbl* pVtbl; }

const(BufferViewDesc)* IBufferView_GetDesc(IBufferView* object) {
    return cast(const(BufferViewDesc)*)IDeviceObject_GetDesc(cast(IDeviceObject*)object);
}
IBuffer** IBufferView_GetBuffer(IBufferView* object) {
    return object.pVtbl.BufferView.GetBuffer(object);
}
