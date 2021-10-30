/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF ANY PROPRIETARY RIGHTS.
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

module bindbc.diligent.graphics.metal.renderdevicemtl;

/// \file
/// Definition of the Diligent::IRenderDeviceMtl interface

#include "../../GraphicsEngine/interface/RenderDevice.h"

#if PLATFORM_TVOS
@protocol MTLAccelerationStructure; // Not available in tvOS
#endif

// {8D483E4A-2D53-47B2-B8D7-276F4CE57F68}
static const INTERFACE_ID IID_RenderDeviceMtl =
    {0x8d483e4a, 0x2d53, 0x47b2, {0xb8, 0xd7, 0x27, 0x6f, 0x4c, 0xe5, 0x7f, 0x68}};

#define DILIGENT_INTERFACE_NAME IRenderDeviceMtl
#include "../../../Primitives/interface/DefineInterfaceHelperMacros.h"

#define IRenderDeviceMtlInclusiveMethods \
    IRenderDeviceInclusiveMethods;       \
    IRenderDeviceMtlMethods RenderDeviceMtl

/// Exposes Metal-specific functionality of a render device.
DILIGENT_BEGIN_INTERFACE(IRenderDeviceMtl, IRenderDevice)
{
    /// Returns the pointer to Metal device (MTLDevice).
    VIRTUAL id<MTLDevice>GetMtlDevice(THIS) CONST PURE;

    /// Creates a texture from existing Metal resource
    VIRTUAL voidCreateTextureFromMtlResource(THIS_
                                                      id<MTLTexture> mtlTexture,
                                                      RESOURCE_STATE InitialState,
                                                      ITexture**     ppTexture) PURE;

    /// Creates a buffer from existing Metal resource
    VIRTUAL voidCreateBufferFromMtlResource(THIS_
                                                     id<MTLBuffer>        mtlBuffer,
                                                     const BufferDesc REF BuffDesc,
                                                     RESOURCE_STATE       InitialState,
                                                     IBuffer**            ppBuffer) PURE;

    /// Creates a buffer from existing Metal resource
    VIRTUAL voidCreateBLASFromMtlResource(THIS_
                                                   id<MTLAccelerationStructure> mtlBLAS,
                                                   const BottomLevelASDesc REF  Desc,
                                                   RESOURCE_STATE               InitialState,
                                                   IBottomLevelAS**             ppBLAS) API_AVAILABLE(ios(14), macosx(11.0)) API_UNAVAILABLE(tvos) PURE;

    /// Creates a buffer from existing Metal resource
    VIRTUAL voidCreateTLASFromMtlResource(THIS_
                                                   id<MTLAccelerationStructure> mtlTLAS,
                                                   const TopLevelASDesc REF     Desc,
                                                   RESOURCE_STATE               InitialState,
                                                   ITopLevelAS**                ppTLAS) API_AVAILABLE(ios(14), macosx(11.0)) API_UNAVAILABLE(tvos) PURE;
};
DILIGENT_END_INTERFACE

#include "../../../Primitives/interface/UndefInterfaceHelperMacros.h"

#if DILIGENT_C_INTERFACE

#    define IRenderDeviceMtl_GetMtlDevice(This)                      CALL_IFACE_METHOD(RenderDeviceMtl, GetMtlDevice,                 This)
#    define IRenderDeviceMtl_GetMtlCommandQueue(This)                CALL_IFACE_METHOD(RenderDeviceMtl, GetMtlCommandQueue,           This)
#    define IRenderDeviceMtl_CreateTextureFromMtlResource(This, ...) CALL_IFACE_METHOD(RenderDeviceMtl, CreateTextureFromMtlResource, This, __VA_ARGS__)
#    define IRenderDeviceMtl_CreateBufferFromMtlResource(This, ...)  CALL_IFACE_METHOD(RenderDeviceMtl, CreateBufferFromMtlResource,  This, __VA_ARGS__)
#    define IRenderDeviceMtl_CreateBLASFromMtlResource(This, ...)    CALL_IFACE_METHOD(RenderDeviceMtl, CreateBLASFromMtlResource,    This, __VA_ARGS__)
#    define IRenderDeviceMtl_CreateTLASFromMtlResource(This, ...)    CALL_IFACE_METHOD(RenderDeviceMtl, CreateTLASFromMtlResource,    This, __VA_ARGS__)

#endif

